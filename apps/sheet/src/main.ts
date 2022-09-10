import { NestFactory } from '@nestjs/core';
import { SheetModule } from './sheet.module';

async function bootstrap() {
  const app = await NestFactory.create(SheetModule);
  await app.listen(3000);
}
bootstrap();
