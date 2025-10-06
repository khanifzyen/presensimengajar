import { IsEnum, IsOptional, IsString } from 'class-validator';
import { Role, AttendanceCategory } from '@prisma/client';

export class UpdateUserDto {
  @IsString()
  @IsOptional()
  name?: string;

  @IsEnum(Role)
  @IsOptional()
  role?: Role;

  @IsEnum(AttendanceCategory)
  @IsOptional()
  attendanceCategory?: AttendanceCategory;
}