import { Module } from '@nestjs/common';
import { AccoutingController } from './accouting.controller';
import { AccoutingService } from './accouting.service';

@Module({
  imports: [],
  controllers: [AccoutingController],
  providers: [AccoutingService],
})
export class AccoutingModule {}
