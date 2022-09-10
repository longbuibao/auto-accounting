import { Injectable } from '@nestjs/common';

@Injectable()
export class AccoutingService {
  getHello(): string {
    return 'Hello World!';
  }
}
