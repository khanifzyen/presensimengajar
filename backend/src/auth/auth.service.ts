import { ForbiddenException, Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateAuthDto } from './dto/create-auth.dto';
import { LoginDto } from './dto/login.dto';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { Role } from '@prisma/client';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
  ) {}

  async signUp(createAuthDto: CreateAuthDto) {
    const { email, password, name, attendanceCategory } = createAuthDto;

    // Check if user already exists
    const existingUser = await this.prisma.user.findUnique({
      where: { email },
    });

    if (existingUser) {
      throw new ForbiddenException('Email already in use');
    }

    // Hash the password
    const salt = await bcrypt.genSalt();
    const hashedPassword = await bcrypt.hash(password, salt);

    // Save the new user to the database
    const user = await this.prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        name,
        attendanceCategory,
        role: Role.TEACHER, // Default role for sign up
      },
    });

    // Return some user data (without password)
    const { password: _, ...result } = user;
    return result;
  }

  async signIn(loginDto: LoginDto) {
    const { email, password } = loginDto;

    // Find the user by email
    const user = await this.prisma.user.findUnique({
      where: { email },
    });

    if (!user) {
      throw new ForbiddenException('Invalid credentials');
    }

    // Compare passwords
    const isPasswordMatching = await bcrypt.compare(password, user.password);

    if (!isPasswordMatching) {
      throw new ForbiddenException('Invalid credentials');
    }

    // Generate JWT payload
    const payload = { sub: user.id, email: user.email, role: user.role };

    // Sign the token
    const accessToken = await this.jwtService.signAsync(payload);

    return {
      access_token: accessToken,
    };
  }
}