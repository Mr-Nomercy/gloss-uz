-- AlterTable
ALTER TABLE "audit_logs" ADD COLUMN     "role" TEXT;

-- CreateIndex
CREATE INDEX "audit_logs_role_created_at_idx" ON "audit_logs"("role", "created_at");
