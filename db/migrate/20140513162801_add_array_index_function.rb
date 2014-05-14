class AddArrayIndexFunction < ActiveRecord::Migration
  def up
    execute <<-EOF
      CREATE OR REPLACE FUNCTION array_idx(anyarray, anyelement)
        RETURNS int AS 
      $$
        SELECT i FROM (
          SELECT generate_series(array_lower($1,1),array_upper($1,1))
        ) g(i)
        WHERE $1[i] = $2
        LIMIT 1;
      $$ LANGUAGE sql IMMUTABLE;
    EOF
  end

  def down
    execute 'DROP FUNCTION array_idx'
  end
end
