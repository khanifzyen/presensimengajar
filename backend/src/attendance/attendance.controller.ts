import { Controller, Post, Body, UseGuards, UseInterceptors, UploadedFile, Req, ParseIntPipe } from '@nestjs/common';
import { AttendanceService } from './attendance.service';
import { CreateAttendanceDto } from './dto/create-attendance.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { FileInterceptor } from '@nestjs/platform-express';

@Controller('attendance')
@UseGuards(JwtAuthGuard) // Protect all routes in this controller
export class AttendanceController {
  constructor(private readonly attendanceService: AttendanceService) {}

  @Post('check-in')
  @UseInterceptors(FileInterceptor('photo')) // 'photo' is the field name for the file
  checkIn(
    @Req() req,
    @Body() createAttendanceDto: CreateAttendanceDto,
    @UploadedFile() photo: Express.Multer.File,
  ) {
    // The user object is attached to the request by JwtAuthGuard
    const userId = req.user.id;
    
    // The ValidationPipe will transform the string values from FormData into numbers
    const dto = new CreateAttendanceDto();
    dto.latitude = parseFloat(createAttendanceDto.latitude as any);
    dto.longitude = parseFloat(createAttendanceDto.longitude as any);
    if (createAttendanceDto.scheduleId) {
      dto.scheduleId = parseInt(createAttendanceDto.scheduleId as any, 10);
    }

    return this.attendanceService.checkIn(userId, dto, photo);
  }
}
