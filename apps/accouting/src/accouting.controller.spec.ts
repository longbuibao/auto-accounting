import { Test, TestingModule } from '@nestjs/testing';
import { AccoutingController } from './accouting.controller';
import { AccoutingService } from './accouting.service';

describe('AccoutingController', () => {
  let accoutingController: AccoutingController;

  beforeEach(async () => {
    const app: TestingModule = await Test.createTestingModule({
      controllers: [AccoutingController],
      providers: [AccoutingService],
    }).compile();

    accoutingController = app.get<AccoutingController>(AccoutingController);
  });

  describe('root', () => {
    it('should return "Hello World!"', () => {
      expect(accoutingController.getHello()).toBe('Hello World!');
    });
  });
});
