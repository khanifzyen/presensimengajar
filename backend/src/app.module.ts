import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { AttendanceModule } from './attendance/attendance.module';
import { SchedulesModule } from './schedules/schedules.module';

@Module({
  imports: [AuthModule, UsersModule, AttendanceModule, SchedulesModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
