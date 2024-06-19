
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE EXTENSION IF NOT EXISTS "pgsodium" WITH SCHEMA "pgsodium";

COMMENT ON SCHEMA "public" IS 'standard public schema';

CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";

CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";

SET default_tablespace = '';

SET default_table_access_method = "heap";

CREATE TABLE IF NOT EXISTS "public"."asignaturas" (
    "id" integer NOT NULL,
    "nombre" character varying(50) NOT NULL,
    "dias_semana" "text"[] NOT NULL,
    "id_usuario" "uuid",
    "fecha_inicio" "date",
    "fecha_final" "date",
    "hora_inicio" time without time zone,
    "hora_final" time without time zone
);

ALTER TABLE "public"."asignaturas" OWNER TO "postgres";

CREATE SEQUENCE IF NOT EXISTS "public"."asignaturas_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "public"."asignaturas_id_seq" OWNER TO "postgres";

ALTER SEQUENCE "public"."asignaturas_id_seq" OWNED BY "public"."asignaturas"."id";

CREATE TABLE IF NOT EXISTS "public"."proyectos" (
    "id" integer NOT NULL,
    "nombre" character varying(50) NOT NULL,
    "fecha_inicio" "date" NOT NULL,
    "fecha_final" "date" NOT NULL,
    "id_usuario" "uuid",
    "id_asignatura" integer
);

ALTER TABLE "public"."proyectos" OWNER TO "postgres";

CREATE SEQUENCE IF NOT EXISTS "public"."proyectos_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "public"."proyectos_id_seq" OWNER TO "postgres";

ALTER SEQUENCE "public"."proyectos_id_seq" OWNED BY "public"."proyectos"."id";

CREATE TABLE IF NOT EXISTS "public"."recordatorios" (
    "id" integer NOT NULL,
    "nombre" character varying(50) NOT NULL,
    "usuario" "uuid" NOT NULL,
    "id_asignatura" integer,
    "tipo" character varying(255) NOT NULL,
    "fecha" "date" NOT NULL,
    "hora_inicio" time without time zone,
    "hora_final" time without time zone,
    "prioridad" integer NOT NULL,
    "temas" character varying(100) NOT NULL,
    "alarma" boolean NOT NULL,
    "id_proyecto" integer
);

ALTER TABLE "public"."recordatorios" OWNER TO "postgres";

CREATE SEQUENCE IF NOT EXISTS "public"."recordatorios_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "public"."recordatorios_id_seq" OWNER TO "postgres";

ALTER SEQUENCE "public"."recordatorios_id_seq" OWNED BY "public"."recordatorios"."id";

CREATE TABLE IF NOT EXISTS "public"."usuarios" (
    "nombre" character varying(100) NOT NULL,
    "correo" character varying(100) NOT NULL,
    "edad" bigint,
    "telefono" bigint,
    "contraseña" character varying(30) NOT NULL,
    "tipo_cuenta" integer,
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL
);

ALTER TABLE "public"."usuarios" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."mazos" (
    "id" int NOT NULL,
    "nombre" character varying(100) NOT NULL,
    "id_usuario" "uuid" NOT NULL,
    "id_asignatura" int NOT NULL
);

ALTER TABLE "public"."mazos" OWNER TO "postgres";

CREATE SEQUENCE IF NOT EXISTS "public"."mazos_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "public"."mazos_id_seq" OWNER TO "postgres";

ALTER SEQUENCE "public"."mazos_id_seq" OWNED BY "public"."mazos"."id";

CREATE TABLE IF NOT EXISTS "public"."flashcards" (
    "id" int NOT NULL,
    "enunciado" character varying(200) NOT NULL,
    "respuesta" character varying(200) NOT NULL,
    "id_usuario" "uuid" NOT NULL,
    "id_mazo" int NOT NULL
);

ALTER TABLE "public"."flashcards" OWNER TO "postgres";

CREATE SEQUENCE IF NOT EXISTS "public"."flashcards_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE "public"."flashcards_id_seq" OWNER TO "postgres";

ALTER SEQUENCE "public"."flashcards_id_seq" OWNED BY "public"."flashcards"."id";

ALTER TABLE ONLY "public"."asignaturas" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."asignaturas_id_seq"'::"regclass");

ALTER TABLE ONLY "public"."proyectos" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."proyectos_id_seq"'::"regclass");

ALTER TABLE ONLY "public"."recordatorios" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."recordatorios_id_seq"'::"regclass");

ALTER TABLE ONLY "public"."mazos" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."mazos_id_seq"'::"regclass");

ALTER TABLE ONLY "public"."flashcards" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."flashcards_id_seq"'::"regclass");

ALTER TABLE ONLY "public"."asignaturas"
    ADD CONSTRAINT "asignaturas_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."proyectos"
    ADD CONSTRAINT "proyectos_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."recordatorios"
    ADD CONSTRAINT "recordatorios_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."usuarios"
    ADD CONSTRAINT "usuarios_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."mazos"
    ADD CONSTRAINT "mazos_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."flashcards"
    ADD CONSTRAINT "flashcards_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."asignaturas"
    ADD CONSTRAINT "asignaturas_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "public"."usuarios"("id");

ALTER TABLE ONLY "public"."proyectos"
    ADD CONSTRAINT "proyectos_id_asignatura_fkey" FOREIGN KEY ("id_asignatura") REFERENCES "public"."asignaturas"("id");

ALTER TABLE ONLY "public"."proyectos"
    ADD CONSTRAINT "proyectos_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "public"."usuarios"("id");

ALTER TABLE ONLY "public"."recordatorios"
    ADD CONSTRAINT "recordatorios_id_asignatura_fkey" FOREIGN KEY ("id_asignatura") REFERENCES "public"."asignaturas"("id");

ALTER TABLE ONLY "public"."recordatorios"
    ADD CONSTRAINT "recordatorios_id_proyecto_fkey" FOREIGN KEY ("id_proyecto") REFERENCES "public"."proyectos"("id");

ALTER TABLE ONLY "public"."recordatorios"
    ADD CONSTRAINT "recordatorios_usuario_fkey" FOREIGN KEY ("usuario") REFERENCES "public"."usuarios"("id");

ALTER TABLE ONLY "public"."mazos"
    ADD CONSTRAINT "mazos_id_asignatura_fkey" FOREIGN KEY ("id_asignatura") REFERENCES "public"."asignaturas"("id");

ALTER TABLE ONLY "public"."mazos"
    ADD CONSTRAINT "mazos_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "public"."usuarios"("id");

ALTER TABLE ONLY "public"."flashcards"
    ADD CONSTRAINT "flashcards_id_mazo_fkey" FOREIGN KEY ("id_mazo") REFERENCES "public"."mazos"("id");

ALTER TABLE ONLY "public"."flashcards"
    ADD CONSTRAINT "flashcards_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "public"."usuarios"("id");

ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";

GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";

GRANT ALL ON TABLE "public"."asignaturas" TO "anon";
GRANT ALL ON TABLE "public"."asignaturas" TO "authenticated";
GRANT ALL ON TABLE "public"."asignaturas" TO "service_role";

GRANT ALL ON SEQUENCE "public"."asignaturas_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."asignaturas_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."asignaturas_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."proyectos" TO "anon";
GRANT ALL ON TABLE "public"."proyectos" TO "authenticated";
GRANT ALL ON TABLE "public"."proyectos" TO "service_role";

GRANT ALL ON SEQUENCE "public"."proyectos_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."proyectos_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."proyectos_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."recordatorios" TO "anon";
GRANT ALL ON TABLE "public"."recordatorios" TO "authenticated";
GRANT ALL ON TABLE "public"."recordatorios" TO "service_role";

GRANT ALL ON SEQUENCE "public"."recordatorios_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."recordatorios_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."recordatorios_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."usuarios" TO "anon";
GRANT ALL ON TABLE "public"."usuarios" TO "authenticated";
GRANT ALL ON TABLE "public"."usuarios" TO "service_role";

GRANT ALL ON TABLE "public"."mazos" TO "anon";
GRANT ALL ON TABLE "public"."mazos" TO "authenticated";
GRANT ALL ON TABLE "public"."mazos" TO "service_role";

GRANT ALL ON SEQUENCE "public"."mazos_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."mazos_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."mazos_id_seq" TO "service_role";

GRANT ALL ON TABLE "public"."flashcards" TO "anon";
GRANT ALL ON TABLE "public"."flashcards" TO "authenticated";
GRANT ALL ON TABLE "public"."flashcards" TO "service_role";

GRANT ALL ON SEQUENCE "public"."flashcards_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."flashcards_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."flashcards_id_seq" TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";

RESET ALL;
