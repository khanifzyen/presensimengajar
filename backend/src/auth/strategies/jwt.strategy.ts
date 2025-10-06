import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env.JWT_SECRET,
    });
  }

  // This method is automatically called by Passport after it has verified the token's signature
  // and that it has not expired. The return value is attached to the `request.user` object.
  async validate(payload: { sub: number; email: string; role: string }) {
    return { id: payload.sub, email: payload.email, role: payload.role };
  }
}
