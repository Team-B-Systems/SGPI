import { plainToInstance } from "class-transformer";
import { validate } from "class-validator";
import { Request, Response, NextFunction } from "express";

export function validationMiddleware<T extends object>(type: new () => T) {
  return async (req: Request, res: Response, next: NextFunction) => {
    const dto = plainToInstance(type, req.body);
    const errors = await validate(dto, {
      whitelist: true,
      forbidNonWhitelisted: true,
    });

    if (errors.length > 0) {
      const formatted = errors.map(err => ({
        property: err.property,
        constraints: err.constraints,
      }));

      return res.status(400).json({
        message: "Erro de validação",
        errors: formatted,
      });
    }

    next();
  };
}
