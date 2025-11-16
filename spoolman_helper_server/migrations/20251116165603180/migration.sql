BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_session_log" ADD COLUMN "userId" text;

--
-- MIGRATION VERSION FOR spoolman_helper
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('spoolman_helper', '20251116165603180', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251116165603180', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20250825102336032-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102336032-v3-0-0', "timestamp" = now();


COMMIT;
