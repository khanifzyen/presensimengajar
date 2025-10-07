import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SchedulesService {
  constructor(private prisma: PrismaService) {}

  async findOne(id: number) {
    const schedule = await this.prisma.schedule.findUnique({
      where: { id },
    });

    if (!schedule) {
      throw new NotFoundException(`Schedule with ID "${id}" not found`);
    }

    return schedule;
  }

  async findToday(userId: number) {
    const now = new Date();
    const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const endOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1);

    const schedule = await this.prisma.schedule.findFirst({
      where: {
        assignedToId: userId,
        startTime: {
          gte: startOfDay,
          lt: endOfDay,
        },
      },
    });

    if (!schedule) {
      throw new NotFoundException('No schedule found for you today.');
    }

    return schedule;
  }
}
