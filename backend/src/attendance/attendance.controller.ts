import { Controller, Post, Body, UseGuards, UseInterceptors, UploadedFile, Req, ParseIntPipe, Param } from '@nestjs/common';
import { AttendanceService } from './attendance.service';
import { CreateAttendanceDto } from './dto/create-attendance.dto';
import { CheckOutDto } from './dto/check-out.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { FileInterceptor } from '@nestjs/platform-express';

@Controller('attendance')
@UseGuards(JwtAuthGuard) // Protect all routes in this controller
export class AttendanceController {
  constructor(private readonly attendanceService: AttendanceService) {}

  @Post('check-in')
  @UseInterceptors(FileInterceptor('photo'))
  checkIn(
    @Req() req,
    @Body() createAttendanceDto: CreateAttendanceDto,
    @UploadedFile() photo: Express.Multer.File,
  ) {
    const userId = req.user.id;
    // Manual parsing is removed. Assuming global ValidationPipe with transform:true.
    return this.attendanceService.checkIn(userId, createAttendanceDto, photo);
  }

  @Post('check-out/:id')
  @UseInterceptors(FileInterceptor('photo'))
  checkOut(
    @Req() req,
    @Param('id', ParseIntPipe) attendanceId: number,
    @Body() checkOutDto: CheckOutDto,
    @UploadedFile() photo: Express.Multer.File,
  ) {
    const userId = req.user.id;
    return this.attendanceService.checkOut(userId, attendanceId, checkOutDto, photo);
  }
}
