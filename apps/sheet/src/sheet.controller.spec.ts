import { Test, TestingModule } from '@nestjs/testing';
import { SheetController } from './sheet.controller';
import { SheetService } from './sheet.service';

describe('SheetController', () => {
  let sheetController: SheetController;

  beforeEach(async () => {
    const app: TestingModule = await Test.createTestingModule({
      controllers: [SheetController],
      providers: [SheetService],
    }).compile();

    sheetController = app.get<SheetController>(SheetController);
  });

  describe('root', () => {
    it('should return "Hello World!"', () => {
      expect(sheetController.getHello()).toBe('Hello World!');
    });
  });
});
