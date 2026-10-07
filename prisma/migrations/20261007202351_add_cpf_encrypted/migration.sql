/*
  Warnings:

  - Added the required column `cpfEncrypted` to the `pedido_registro` table without a default value. This is not possible if the table is not empty.
  - Added the required column `cpfEncrypted` to the `users` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "pedido_registro" ADD COLUMN     "cpfEncrypted" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "users" ADD COLUMN     "cpfEncrypted" TEXT NOT NULL;
