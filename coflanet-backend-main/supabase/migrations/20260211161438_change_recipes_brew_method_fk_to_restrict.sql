-- recipes → brew_methods FK를 CASCADE에서 RESTRICT로 변경
-- brew_methods는 시스템 참조 데이터이므로 실수 삭제 방지
ALTER TABLE recipes
  DROP CONSTRAINT recipes_brew_method_id_fkey,
  ADD CONSTRAINT recipes_brew_method_id_fkey
    FOREIGN KEY (brew_method_id) REFERENCES brew_methods(id)
    ON DELETE RESTRICT;
