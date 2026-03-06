BEGIN;

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES
  ('bean-images', 'bean-images', true, 2097152, ARRAY['image/png', 'image/webp', 'image/jpeg']),
  ('avatars', 'avatars', false, 1048576, ARRAY['image/png', 'image/webp', 'image/jpeg']),
  ('recipe-illustrations', 'recipe-illustrations', true, 512000, ARRAY['image/png', 'image/webp', 'image/svg+xml'])
ON CONFLICT (id) DO UPDATE
SET
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

DROP POLICY IF EXISTS avatars_select_own ON storage.objects;
CREATE POLICY avatars_select_own ON storage.objects
  FOR SELECT TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = (SELECT auth.uid())::text
  );

DROP POLICY IF EXISTS avatars_insert_own ON storage.objects;
CREATE POLICY avatars_insert_own ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = (SELECT auth.uid())::text
  );

DROP POLICY IF EXISTS avatars_update_own ON storage.objects;
CREATE POLICY avatars_update_own ON storage.objects
  FOR UPDATE TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = (SELECT auth.uid())::text
  )
  WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = (SELECT auth.uid())::text
  );

DROP POLICY IF EXISTS avatars_delete_own ON storage.objects;
CREATE POLICY avatars_delete_own ON storage.objects
  FOR DELETE TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = (SELECT auth.uid())::text
  );

DROP POLICY IF EXISTS bean_images_select_public ON storage.objects;
CREATE POLICY bean_images_select_public ON storage.objects
  FOR SELECT TO anon, authenticated
  USING (bucket_id = 'bean-images');

DROP POLICY IF EXISTS recipe_illustrations_select_public ON storage.objects;
CREATE POLICY recipe_illustrations_select_public ON storage.objects
  FOR SELECT TO anon, authenticated
  USING (bucket_id = 'recipe-illustrations');

COMMIT;
