import { Injectable, BadRequestException, NotFoundException, ForbiddenException } from '@nestjs/common';
import { CreateAttendanceDto } from './dto/create-attendance.dto';
import { CheckOutDto } from './dto/check-out.dto';
import { PrismaService } from '../prisma/prisma.service';
import { CloudinaryService } from '../cloudinary/cloudinary.service';
import { AttendanceStatus, Schedule } from '@prisma/client';

@Injectable()
export class AttendanceService {
  constructor(
    private prisma: PrismaService,
    private cloudinary: CloudinaryService,
  ) {}

  async checkIn(
    userId: number,
    createAttendanceDto: CreateAttendanceDto,
    photo: Express.Multer.File,
  ) {
    if (!photo) {
      throw new BadRequestException('Photo is required for check-in.');
    }
    
    if (!createAttendanceDto.scheduleId) {
      throw new BadRequestException('Schedule ID is required for check-in.');
    }

    const schedule = await this.prisma.schedule.findUnique({
      where: { id: createAttendanceDto.scheduleId },
    });

    if (!schedule) {
      throw new NotFoundException('Schedule not found.');
    }

    const distance = this.getDistanceInMeters(
      { lat: createAttendanceDto.latitude, lon: createAttendanceDto.longitude },
      { lat: schedule.latitude, lon: schedule.longitude },
    );

    if (distance > schedule.radius) {
      throw new BadRequestException(
        `You are ${distance.toFixed(0)} meters away. Please move within the ${schedule.radius}m radius to check in.`,
      );
    }

    const status = this.calculateCheckInStatus(schedule);

    const uploadResult = await this.cloudinary.uploadFile(photo).catch((error) => {
      throw new BadRequestException(`Failed to upload photo: ${error.message}`);
    });

    const attendanceRecord = await this.prisma.attendanceRecord.create({
      data: {
        userId: userId,
        checkInTime: new Date(),
        checkInLatitude: createAttendanceDto.latitude,
        checkInLongitude: createAttendanceDto.longitude,
        checkInPhotoUrl: uploadResult.secure_url,
        status: status,
        scheduleId: createAttendanceDto.scheduleId,
      },
    });

    return attendanceRecord;
  }

  async checkOut(
    userId: number,
    attendanceId: number,
    checkOutDto: CheckOutDto,
    photo: Express.Multer.File,
  ) {
    if (!photo) {
      throw new BadRequestException('Photo is required for check-out.');
    }

    const attendanceRecord = await this.prisma.attendanceRecord.findUnique({
      where: { id: attendanceId },
      include: { schedule: true }, // Include schedule for end time validation
    });

    if (!attendanceRecord) {
      throw new NotFoundException('Attendance record not found.');
    }

    if (attendanceRecord.userId !== userId) {
      throw new ForbiddenException('You are not authorized to check out for this record.');
    }

    if (attendanceRecord.checkOutTime) {
      throw new BadRequestException('Already checked out for this attendance record.');
    }

    // Optional: Validate checkout location
    if (attendanceRecord.schedule) {
        const distance = this.getDistanceInMeters(
            { lat: checkOutDto.latitude, lon: checkOutDto.longitude },
            { lat: attendanceRecord.schedule.latitude, lon: attendanceRecord.schedule.longitude },
        );
        if (distance > attendanceRecord.schedule.radius) {
            throw new BadRequestException(
                `You are ${distance.toFixed(0)} meters away. Please move within the ${attendanceRecord.schedule.radius}m radius to check out.`,
            );
        }
    }

    const status = this.calculateCheckOutStatus(attendanceRecord.status, attendanceRecord.schedule);

    const uploadResult = await this.cloudinary.uploadFile(photo).catch((error) => {
      throw new BadRequestException(`Failed to upload photo: ${error.message}`);
    });

    const updatedRecord = await this.prisma.attendanceRecord.update({
      where: { id: attendanceId },
      data: {
        checkOutTime: new Date(),
        checkOutPhotoUrl: uploadResult.secure_url,
        checkOutLatitude: checkOutDto.latitude,
        checkOutLongitude: checkOutDto.longitude,
        status: status, 
      },
    });

    return updatedRecord;
  }

  private calculateCheckInStatus(schedule: Schedule): AttendanceStatus {
    const now = new Date();
    const startTime = new Date(schedule.startTime);
    const tolerance = 10 * 60 * 1000; // 10 minutes
    const lateTime = new Date(startTime.getTime() + tolerance);

    if (now > lateTime) {
      return AttendanceStatus.TERLAMBAT;
    }
    return AttendanceStatus.HADIR;
  }

  private calculateCheckOutStatus(currentStatus: AttendanceStatus, schedule: Schedule | null): AttendanceStatus {
      if (!schedule) {
          return currentStatus; // If no schedule, can't determine early leave, so keep status as is
      }
      const now = new Date();
      const endTime = new Date(schedule.endTime);
      const tolerance = 10 * 60 * 1000; // 10 minutes
      const earlyLeaveTime = new Date(endTime.getTime() - tolerance);

      if (now < earlyLeaveTime) {
          return AttendanceStatus.PULANG_CEPAT;
      }

      return currentStatus;
  }

  private getDistanceInMeters(
    p1: { lat: number; lon: number },
    p2: { lat: number; lon: number },
  ): number {
    const R = 6371e3; // Earth's radius in meters
    const φ1 = (p1.lat * Math.PI) / 180;
    const φ2 = (p2.lat * Math.PI) / 180;
    const Δφ = ((p2.lat - p1.lat) * Math.PI) / 180;
    const Δλ = ((p2.lon - p1.lon) * Math.PI) / 180;

    const a =
      Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
      Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ / 2) * Math.sin(Δλ / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return R * c; // in metres
  }
}
