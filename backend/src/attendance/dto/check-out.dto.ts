import { IsLatitude, IsLongitude, IsNotEmpty } from 'class-validator';

export class CheckOutDto {
  @IsNotEmpty()
  @IsLatitude()
  latitude: number;

  @IsNotEmpty()
  @IsLongitude()
  longitude: number;
}
