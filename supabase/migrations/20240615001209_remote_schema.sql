-- revoke delete on table "public"."flashcards" from "anon";

-- revoke insert on table "public"."flashcards" from "anon";

-- revoke references on table "public"."flashcards" from "anon";

-- revoke select on table "public"."flashcards" from "anon";

-- revoke trigger on table "public"."flashcards" from "anon";

-- revoke truncate on table "public"."flashcards" from "anon";

-- revoke update on table "public"."flashcards" from "anon";

-- revoke delete on table "public"."flashcards" from "authenticated";

-- revoke insert on table "public"."flashcards" from "authenticated";

-- revoke references on table "public"."flashcards" from "authenticated";

-- revoke select on table "public"."flashcards" from "authenticated";

-- revoke trigger on table "public"."flashcards" from "authenticated";

-- revoke truncate on table "public"."flashcards" from "authenticated";

-- revoke update on table "public"."flashcards" from "authenticated";

-- revoke delete on table "public"."flashcards" from "service_role";

-- revoke insert on table "public"."flashcards" from "service_role";

-- revoke references on table "public"."flashcards" from "service_role";

-- revoke select on table "public"."flashcards" from "service_role";

-- revoke trigger on table "public"."flashcards" from "service_role";

-- revoke truncate on table "public"."flashcards" from "service_role";

-- revoke update on table "public"."flashcards" from "service_role";

-- revoke delete on table "public"."mazos" from "anon";

-- revoke insert on table "public"."mazos" from "anon";

-- revoke references on table "public"."mazos" from "anon";

-- revoke select on table "public"."mazos" from "anon";

-- revoke trigger on table "public"."mazos" from "anon";

-- revoke truncate on table "public"."mazos" from "anon";

-- revoke update on table "public"."mazos" from "anon";

-- revoke delete on table "public"."mazos" from "authenticated";

-- revoke insert on table "public"."mazos" from "authenticated";

-- revoke references on table "public"."mazos" from "authenticated";

-- revoke select on table "public"."mazos" from "authenticated";

-- revoke trigger on table "public"."mazos" from "authenticated";

-- revoke truncate on table "public"."mazos" from "authenticated";

-- revoke update on table "public"."mazos" from "authenticated";

-- revoke delete on table "public"."mazos" from "service_role";

-- revoke insert on table "public"."mazos" from "service_role";

-- revoke references on table "public"."mazos" from "service_role";

-- revoke select on table "public"."mazos" from "service_role";

-- revoke trigger on table "public"."mazos" from "service_role";

-- revoke truncate on table "public"."mazos" from "service_role";

-- revoke update on table "public"."mazos" from "service_role";

-- alter table "public"."flashcards" drop constraint "flashcards_id_mazo_fkey";

-- alter table "public"."flashcards" drop constraint "flashcards_id_usuario_fkey";

-- alter table "public"."mazos" drop constraint "mazos_id_asignatura_fkey";

-- alter table "public"."mazos" drop constraint "mazos_id_usuario_fkey";

-- alter table "public"."flashcards" drop constraint "flashcards_pkey";

-- alter table "public"."mazos" drop constraint "mazos_pkey";

-- drop index if exists "public"."flashcards_pkey";

-- drop index if exists "public"."mazos_pkey";

-- drop table "public"."flashcards";

-- drop table "public"."mazos";

-- drop sequence if exists "public"."flashcards_id_seq";

-- drop sequence if exists "public"."mazos_id_seq";


