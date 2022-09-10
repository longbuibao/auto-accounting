import { Injectable } from '@nestjs/common';

@Injectable()
export class SheetService {
  getHello(): string {
    return 'Hello World!';
  }
}
