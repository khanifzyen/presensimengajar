import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting database seeding...');

  // Hash password function
  const hashPassword = async (password: string): Promise<string> => {
    return bcrypt.hash(password, 10);
  };

  // 1. Create Admin User
  console.log('👤 Creating admin user...');
  const adminPassword = await hashPassword('admin123');
  const admin = await prisma.user.upsert({
    where: { email: 'admin@presensi.sch.id' },
    update: {},
    create: {
      email: 'admin@presensi.sch.id',
      password: adminPassword,
      name: 'Administrator',
      role: 'ADMIN',
      attendanceCategory: 'KEHADIRAN_KERJA',
    },
  });

  // 2. Create Teacher Users
  console.log('👨‍🏫 Creating teacher users...');
  const teacherPassword = await hashPassword('teacher123');

  const teacher1 = await prisma.user.upsert({
    where: { email: 'ahmad.santoso@presensi.sch.id' },
    update: {},
    create: {
      email: 'ahmad.santoso@presensi.sch.id',
      password: teacherPassword,
      name: 'Ahmad Santoso, S.Pd.',
      role: 'TEACHER',
      attendanceCategory: 'PENGAJARAN',
    },
  });

  const teacher2 = await prisma.user.upsert({
    where: { email: 'siti.nurhaliza@presensi.sch.id' },
    update: {},
    create: {
      email: 'siti.nurhaliza@presensi.sch.id',
      password: teacherPassword,
      name: 'Siti Nurhaliza, S.Pd.',
      role: 'TEACHER',
      attendanceCategory: 'PENGAJARAN',
    },
  });

  const teacher3 = await prisma.user.upsert({
    where: { email: 'budi.pratama@presensi.sch.id' },
    update: {},
    create: {
      email: 'budi.pratama@presensi.sch.id',
      password: teacherPassword,
      name: 'Budi Pratama, S.Kom.',
      role: 'TEACHER',
      attendanceCategory: 'KEHADIRAN_KERJA',
    },
  });

  const teacher4 = await prisma.user.upsert({
    where: { email: 'diana.wijaya@presensi.sch.id' },
    update: {},
    create: {
      email: 'diana.wijaya@presensi.sch.id',
      password: teacherPassword,
      name: 'Diana Wijaya, M.Pd.',
      role: 'TEACHER',
      attendanceCategory: 'PENGAJARAN',
    },
  });

  // 3. Create Schedules
  console.log('📅 Creating schedules...');

  // Location coordinates for a sample school in Indonesia
  const schoolLatitude = -6.2088;
  const schoolLongitude = 106.8456;
  const schoolRadius = 500; // 500 meters

  // Monday Schedule
  const mondaySchedule = await prisma.schedule.create({
    data: {
      name: 'Jadwal Senin - Guru Pengajaran',
      startTime: new Date('2024-01-01T07:00:00'),
      endTime: new Date('2024-01-01T15:00:00'),
      latitude: schoolLatitude,
      longitude: schoolLongitude,
      radius: schoolRadius,
      assignedToId: teacher1.id,
    },
  });

  // Tuesday Schedule
  const tuesdaySchedule = await prisma.schedule.create({
    data: {
      name: 'Jadwal Selasa - Guru Pengajaran',
      startTime: new Date('2024-01-01T07:00:00'),
      endTime: new Date('2024-01-01T15:00:00'),
      latitude: schoolLatitude,
      longitude: schoolLongitude,
      radius: schoolRadius,
      assignedToId: teacher2.id,
    },
  });

  // Wednesday Schedule
  const wednesdaySchedule = await prisma.schedule.create({
    data: {
      name: 'Jadwal Rabu - Guru Pengajaran',
      startTime: new Date('2024-01-01T07:30:00'),
      endTime: new Date('2024-01-01T16:00:00'),
      latitude: schoolLatitude,
      longitude: schoolLongitude,
      radius: schoolRadius,
      assignedToId: teacher1.id,
    },
  });

  // Thursday Schedule
  const thursdaySchedule = await prisma.schedule.create({
    data: {
      name: 'Jadwal Kamis - Guru Pengajaran',
      startTime: new Date('2024-01-01T07:00:00'),
      endTime: new Date('2024-01-01T15:00:00'),
      latitude: schoolLatitude,
      longitude: schoolLongitude,
      radius: schoolRadius,
      assignedToId: teacher4.id,
    },
  });

  // Friday Schedule
  const fridaySchedule = await prisma.schedule.create({
    data: {
      name: 'Jadwal Jumat - Guru Pengajaran',
      startTime: new Date('2024-01-01T07:30:00'),
      endTime: new Date('2024-01-01T16:00:00'),
      latitude: schoolLatitude,
      longitude: schoolLongitude,
      radius: schoolRadius,
      assignedToId: teacher3.id,
    },
  });

  // Staff Work Schedule (KEHADIRAN_KERJA)
  const staffSchedule = await prisma.schedule.create({
    data: {
      name: 'Jadwal Kantor - Staff',
      startTime: new Date('2024-01-01T08:00:00'),
      endTime: new Date('2024-01-01T17:00:00'),
      latitude: schoolLatitude,
      longitude: schoolLongitude,
      radius: schoolRadius,
      assignedToId: teacher3.id,
    },
  });

  // 4. Create Sample Attendance Records
  console.log('📊 Creating sample attendance records...');

  // Today's date for sample records
  const today = new Date();
  const todayStart = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 7, 0, 0);
  const todayEnd = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 15, 0, 0);

  // Sample check-in record for teacher1
  const sampleAttendance1 = await prisma.attendanceRecord.create({
    data: {
      userId: teacher1.id,
      scheduleId: mondaySchedule.id,
      checkInTime: new Date(today.getFullYear(), today.getMonth(), today.getDate(), 7, 15, 0),
      checkInPhotoUrl: 'https://res.cloudinary.com/demo/image/upload/w_100,h_100,c_fill,g_face,r_max/dummy-sample.jpg',
      checkInLatitude: schoolLatitude + 0.001,
      checkInLongitude: schoolLongitude + 0.001,
      checkOutTime: new Date(today.getFullYear(), today.getMonth(), today.getDate(), 15, 30, 0),
      checkOutPhotoUrl: 'https://res.cloudinary.com/demo/image/upload/w_100,h_100,c_fill,g_face,r_max/dummy-sample2.jpg',
      checkOutLatitude: schoolLatitude - 0.001,
      checkOutLongitude: schoolLongitude - 0.001,
      status: 'HADIR',
    },
  });

  // Sample late attendance record for teacher2
  const sampleAttendance2 = await prisma.attendanceRecord.create({
    data: {
      userId: teacher2.id,
      scheduleId: tuesdaySchedule.id,
      checkInTime: new Date(today.getFullYear(), today.getMonth(), today.getDate(), 7, 20, 0), // 20 minutes late
      checkInPhotoUrl: 'https://res.cloudinary.com/demo/image/upload/w_100,h_100,c_fill,g_face,r_max/dummy-sample3.jpg',
      checkInLatitude: schoolLatitude + 0.002,
      checkInLongitude: schoolLongitude - 0.001,
      checkOutTime: new Date(today.getFullYear(), today.getMonth(), today.getDate(), 14, 45, 0), // Early checkout
      checkOutPhotoUrl: 'https://res.cloudinary.com/demo/image/upload/w_100,h_100,c_fill,g_face,r_max/dummy-sample4.jpg',
      checkOutLatitude: schoolLatitude - 0.002,
      checkOutLongitude: schoolLongitude + 0.001,
      status: 'TERLAMBAT',
    },
  });

  // 5. Create Sample Leave Requests
  console.log('📝 Creating sample leave requests...');

  const leaveRequest1 = await prisma.leaveRequest.create({
    data: {
      userId: teacher1.id,
      reason: 'Acara keluarga penting',
      startDate: new Date(today.getFullYear(), today.getMonth(), today.getDate() + 2),
      endDate: new Date(today.getFullYear(), today.getMonth(), today.getDate() + 3),
      status: 'PENDING',
    },
  });

  const leaveRequest2 = await prisma.leaveRequest.create({
    data: {
      userId: teacher2.id,
      reason: 'Sakit demam',
      startDate: new Date(today.getFullYear(), today.getMonth(), today.getDate() - 1),
      endDate: new Date(today.getFullYear(), today.getMonth(), today.getDate()),
      status: 'APPROVED',
      approvedById: admin.id,
    },
  });

  console.log('✅ Database seeding completed successfully!');
  console.log('\n📋 Summary of created data:');
  console.log(`👤 Users: 5 (1 Admin, 4 Teachers)`);
  console.log(`📅 Schedules: 6`);
  console.log(`📊 Attendance Records: 2`);
  console.log(`📝 Leave Requests: 2`);

  console.log('\n🔑 Login Credentials:');
  console.log('Admin: admin@presensi.sch.id / admin123');
  console.log('Teacher: [teacher-email] / teacher123');
  console.log('\nTeacher Emails:');
  console.log('- ahmad.santoso@presensi.sch.id');
  console.log('- siti.nurhaliza@presensi.sch.id');
  console.log('- budi.pratama@presensi.sch.id');
  console.log('- diana.wijaya@presensi.sch.id');
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error('❌ Error during seeding:', e);
    await prisma.$disconnect();
    process.exit(1);
  });