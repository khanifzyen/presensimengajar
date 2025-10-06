import { IsLatitude, IsLongitude, IsNumber, IsOptional } from 'class-validator';

export class CreateAttendanceDto {
  @IsLatitude()
  latitude: number;

  @IsLongitude()
  longitude: number;

  // The schedule might be optional depending on the attendance category (e.g. Kehadiran Kerja)
  @IsNumber()
  @IsOptional()
  scheduleId?: number;
}