import { Injectable, BadRequestException } from '@nestjs/common';
import { CreateAttendanceDto } from './dto/create-attendance.dto';
import { PrismaService } from '../prisma/prisma.service';
import { CloudinaryService } from '../cloudinary/cloudinary.service';
import { AttendanceStatus } from '@prisma/client';

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

    // 1. Upload photo to Cloudinary
    const uploadResult = await this.cloudinary.uploadFile(photo).catch((error) => {
      throw new BadRequestException(`Failed to upload photo: ${error.message}`);
    });

    // TODO: Implement location validation logic
    // TODO: Implement status calculation (Hadir vs Terlambat)

    // 2. Create attendance record in the database
    const attendanceRecord = await this.prisma.attendanceRecord.create({
      data: {
        userId: userId,
        checkInTime: new Date(),
        checkInLatitude: createAttendanceDto.latitude,
        checkInLongitude: createAttendanceDto.longitude,
        checkInPhotoUrl: uploadResult.secure_url,
        status: AttendanceStatus.HADIR, // Default status for now
        scheduleId: createAttendanceDto.scheduleId,
      },
    });

    return attendanceRecord;
  }

  // Placeholder for check-out logic
  // async checkOut(attendanceId: number, photo: Express.Multer.File) { ... }
}