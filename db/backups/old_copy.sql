PGDMP         %            	    x            mealplan    12.4    12.4 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    17716    mealplan    DATABASE     z   CREATE DATABASE mealplan WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE mealplan;
                postgres    false                        3079    17746    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false            �           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    3                        3079    18040 	   uuid-ossp 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
    DROP EXTENSION "uuid-ossp";
                   false            �           0    0    EXTENSION "uuid-ossp"    COMMENT     W   COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
                        false    2            �            1259    18095 	   tbl_files    TABLE     �   CREATE TABLE public.tbl_files (
    id integer NOT NULL,
    name text NOT NULL,
    size integer NOT NULL,
    mimetype text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL
);
    DROP TABLE public.tbl_files;
       public         heap    postgres    false            �           0    0    TABLE tbl_files    ACL     ,   GRANT ALL ON TABLE public.tbl_files TO api;
          public          postgres    false    226            *           1255    18115 /   func_files_create(text, integer, text, integer)    FUNCTION     �  CREATE FUNCTION public.func_files_create(p_name text, p_size integer, p_mimetype text, p_created_by integer) RETURNS SETOF public.tbl_files
    LANGUAGE plpgsql
    AS $$
	DECLARE	
		v_new_file_id integer;
	BEGIN
		INSERT INTO tbl_files(
			name,
			size,
			mimetype,
			created_by
		) VALUES (
			p_name,
			p_size,
			p_mimetype,
			p_created_by
		) RETURNING id INTO v_new_file_id;
		
		RETURN QUERY
			SELECT * FROM tbl_files WHERE id = v_new_file_id;
	END;
$$;
 l   DROP FUNCTION public.func_files_create(p_name text, p_size integer, p_mimetype text, p_created_by integer);
       public          postgres    false    226            �           0    0 ^   FUNCTION func_files_create(p_name text, p_size integer, p_mimetype text, p_created_by integer)    ACL     {   GRANT ALL ON FUNCTION public.func_files_create(p_name text, p_size integer, p_mimetype text, p_created_by integer) TO api;
          public          postgres    false    298            �            1259    17800    tbl_fooditems    TABLE     �   CREATE TABLE public.tbl_fooditems (
    id integer NOT NULL,
    name text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL,
    reviewed timestamp without time zone,
    reviewed_by integer
);
 !   DROP TABLE public.tbl_fooditems;
       public         heap    postgres    false            �           0    0    TABLE tbl_fooditems    ACL     0   GRANT ALL ON TABLE public.tbl_fooditems TO api;
          public          postgres    false    208            '           1255    18110 $   func_fooditems_create(text, integer)    FUNCTION     �  CREATE FUNCTION public.func_fooditems_create(p_name text, p_created_by integer) RETURNS SETOF public.tbl_fooditems
    LANGUAGE plpgsql
    AS $$
	DECLARE
		v_new_fooditem_id integer;
	BEGIN
		INSERT INTO tbl_fooditems(
			name,
			created_by
		) VALUES (
			p_name,
			p_created_by
		) RETURNING
			id INTO v_new_fooditem_id;
			
		RETURN QUERY
			SELECT * FROM tbl_fooditems WHERE id = v_new_fooditem_id;
	END;
$$;
 O   DROP FUNCTION public.func_fooditems_create(p_name text, p_created_by integer);
       public          postgres    false    208            �           0    0 A   FUNCTION func_fooditems_create(p_name text, p_created_by integer)    ACL     ^   GRANT ALL ON FUNCTION public.func_fooditems_create(p_name text, p_created_by integer) TO api;
          public          postgres    false    295            �            1259    17867    tbl_mealplans    TABLE     �   CREATE TABLE public.tbl_mealplans (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    public boolean DEFAULT false NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL
);
 !   DROP TABLE public.tbl_mealplans;
       public         heap    postgres    false            �           0    0    TABLE tbl_mealplans    ACL     0   GRANT ALL ON TABLE public.tbl_mealplans TO api;
          public          postgres    false    215            0           1255    26062 *   func_mealplans_create(text, text, integer)    FUNCTION     �  CREATE FUNCTION public.func_mealplans_create(p_name text, p_recipes_json text, p_created_by integer) RETURNS SETOF public.tbl_mealplans
    LANGUAGE plpgsql
    AS $$
	DECLARE
		v_new_mealplan_id integer;
	BEGIN
		-- validate input
		IF p_name IS NULL OR char_length(p_name) = 0 THEN
			RAISE EXCEPTION USING HINT = 'Missing plan title.';
		END IF;
		
		-- create plan
		INSERT INTO tbl_mealplans(
			name,
			created_by
		) VALUES (
			p_name,
			p_created_by
		) RETURNING id INTO v_new_mealplan_id;
		
		-- add to creators favorites
		INSERT INTO tbl_users_mealplans(
			mealplan_id,
			created_by
		) VALUES (
			v_new_mealplan_id,
			p_created_by
		);
		
		-- add recipes
		INSERT INTO tbl_mealplans_recipes(
			mealplan_id,
			recipe_id,
			created_by
		)
		SELECT
			v_new_mealplan_id,
			i.id,
			p_created_by
		FROM
			json_to_recordset(p_recipes_json::json) AS i (
				id integer
			);
		
		-- return new plan
		RETURN QUERY
			SELECT * FROM tbl_mealplans WHERE id = v_new_mealplan_id;
	END;
$$;
 d   DROP FUNCTION public.func_mealplans_create(p_name text, p_recipes_json text, p_created_by integer);
       public          postgres    false    215            �           0    0 V   FUNCTION func_mealplans_create(p_name text, p_recipes_json text, p_created_by integer)    ACL     s   GRANT ALL ON FUNCTION public.func_mealplans_create(p_name text, p_recipes_json text, p_created_by integer) TO api;
          public          postgres    false    304            �            1259    17834    tbl_recipes    TABLE     ?  CREATE TABLE public.tbl_recipes (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL,
    cooking_time integer,
    portions integer,
    file_id integer,
    vegan boolean DEFAULT false NOT NULL,
    vegetarian boolean DEFAULT false NOT NULL,
    gluten_free boolean DEFAULT false NOT NULL,
    allergen_milk boolean DEFAULT false NOT NULL,
    allergen_egg boolean DEFAULT false NOT NULL,
    allergen_nuts boolean DEFAULT false NOT NULL,
    allergen_wheat boolean DEFAULT false NOT NULL,
    allergen_soy boolean DEFAULT false NOT NULL,
    allergen_fish boolean DEFAULT false NOT NULL,
    allergen_shellfish boolean DEFAULT false NOT NULL,
    reviewed timestamp without time zone,
    reviewed_by integer
);
    DROP TABLE public.tbl_recipes;
       public         heap    postgres    false            �           0    0    TABLE tbl_recipes    ACL     .   GRANT ALL ON TABLE public.tbl_recipes TO api;
          public          postgres    false    212            +           1255    18150 �   func_recipes_create(text, text, integer, integer, integer, boolean, boolean, boolean, boolean, boolean, boolean, boolean, boolean, boolean, boolean, text, text, integer)    FUNCTION     "
  CREATE FUNCTION public.func_recipes_create(p_name text, p_description text, p_cooking_time integer, p_portions integer, p_file_id integer, p_vegan boolean, p_vegetarian boolean, p_gluten_free boolean, p_allergen_milk boolean, p_allergen_egg boolean, p_allergen_nuts boolean, p_allergen_wheat boolean, p_allergen_soy boolean, p_allergen_fish boolean, p_allergen_shellfish boolean, p_ingredients text, p_instructions text, p_created_by integer) RETURNS SETOF public.tbl_recipes
    LANGUAGE plpgsql
    AS $$
	DECLARE
		v_new_recipe_id integer;
	BEGIN
		IF p_name IS NULL OR char_length(p_name) = 0 THEN
			RAISE EXCEPTION USING HINT = 'Missing title.';
		END IF;
		
		IF p_description IS NULL OR char_length(p_description) = 0 THEN
			RAISE EXCEPTION USING HINT = 'Missing description.';
		END IF;
		
		IF p_cooking_time IS NULL OR p_cooking_time = 0 THEN
			RAISE EXCEPTION USING HINT = 'Missing cooking time.';
		END IF;
		
		IF p_portions IS NULL OR p_portions = 0 THEN
			RAISE EXCEPTION USING HINT = 'Missing portions.';
		END IF;
		
		IF NOT EXISTS(SELECT id FROM tbl_files WHERE id = p_file_id) THEN
			RAISE EXCEPTION USING HINT = 'Missing image.';
		END IF;
		
		-- create recipe
		INSERT INTO tbl_recipes(
			name,
			description,
			cooking_time,
			portions,
			file_id,
			
			vegan,
			vegetarian,
			gluten_free,
			
			allergen_milk,
			allergen_egg,
			allergen_nuts,
			allergen_wheat,
			allergen_soy,
			allergen_fish,
			allergen_shellfish,
			
			created_by
		) VALUES (
			p_name,
			p_description,
			p_cooking_time,
			p_portions,
			p_file_id,
			
			p_vegan,
			p_vegetarian,
			p_gluten_free,
			
			p_allergen_milk,
			p_allergen_egg,
			p_allergen_nuts,
			p_allergen_wheat,
			p_allergen_soy,
			p_allergen_fish,
			p_allergen_shellfish,
			
			p_created_by
		) RETURNING id INTO v_new_recipe_id;
		
		
		-- add ingredients
		INSERT INTO tbl_recipes_ingredients(
			recipe_id,
			fooditem_id,
			measurement_id,
			amount,
			created_by
		)
		SELECT
			v_new_recipe_id,
			i.fooditem_id,
			i.measurement_id,
			i.amount,
			p_created_by
		FROM
			json_to_recordset(p_ingredients::json) AS i (
				fooditem_id integer,
				measurement_id integer,
				amount integer
			);
			
		-- add instructions
		INSERT INTO tbl_recipes_instructions (
			recipe_id,
			number,
			instruction,
			created_by
		)
		SELECT
			v_new_recipe_id,
			i.number,
			i.instruction,
			p_created_by
		FROM
			json_to_recordset(p_instructions::json) AS i (
				number integer,
				instruction text
			);
			
		RETURN QUERY
			SELECT * FROM tbl_recipes WHERE id = v_new_recipe_id;
	END;
$$;
 �  DROP FUNCTION public.func_recipes_create(p_name text, p_description text, p_cooking_time integer, p_portions integer, p_file_id integer, p_vegan boolean, p_vegetarian boolean, p_gluten_free boolean, p_allergen_milk boolean, p_allergen_egg boolean, p_allergen_nuts boolean, p_allergen_wheat boolean, p_allergen_soy boolean, p_allergen_fish boolean, p_allergen_shellfish boolean, p_ingredients text, p_instructions text, p_created_by integer);
       public          postgres    false    212            �           0    0 �  FUNCTION func_recipes_create(p_name text, p_description text, p_cooking_time integer, p_portions integer, p_file_id integer, p_vegan boolean, p_vegetarian boolean, p_gluten_free boolean, p_allergen_milk boolean, p_allergen_egg boolean, p_allergen_nuts boolean, p_allergen_wheat boolean, p_allergen_soy boolean, p_allergen_fish boolean, p_allergen_shellfish boolean, p_ingredients text, p_instructions text, p_created_by integer)    ACL     �  GRANT ALL ON FUNCTION public.func_recipes_create(p_name text, p_description text, p_cooking_time integer, p_portions integer, p_file_id integer, p_vegan boolean, p_vegetarian boolean, p_gluten_free boolean, p_allergen_milk boolean, p_allergen_egg boolean, p_allergen_nuts boolean, p_allergen_wheat boolean, p_allergen_soy boolean, p_allergen_fish boolean, p_allergen_shellfish boolean, p_ingredients text, p_instructions text, p_created_by integer) TO api;
          public          postgres    false    299            �            1259    18161    tbl_recipes_ratings    TABLE     5  CREATE TABLE public.tbl_recipes_ratings (
    recipe_id integer NOT NULL,
    rating integer NOT NULL,
    comment text,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL,
    CONSTRAINT ch_tbl_recipes_ratings_rating CHECK (((rating >= 0) AND (rating <= 10)))
);
 '   DROP TABLE public.tbl_recipes_ratings;
       public         heap    postgres    false            �           0    0    TABLE tbl_recipes_ratings    ACL     6   GRANT ALL ON TABLE public.tbl_recipes_ratings TO api;
          public          postgres    false    228            %           1255    25968 <   func_recipes_ratings_create(integer, integer, text, integer)    FUNCTION     �  CREATE FUNCTION public.func_recipes_ratings_create(p_recipe_id integer, p_rating integer, p_comment text, p_created_by integer) RETURNS SETOF public.tbl_recipes_ratings
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF NOT EXISTS(SELECT id FROM tbl_recipes WHERE id = p_recipe_id) THEN
			RAISE EXCEPTION USING HINT = 'Invalid recipe reference.';
		END IF;
		
		IF EXISTS(SELECT rating FROM tbl_recipes_ratings WHERE recipe_id = p_recipe_id AND created_by = p_created_by) THEN
			RAISE EXCEPTION USING HINT = 'You have already rated this recipe.';
		END IF;
		
		IF p_rating IS NULL THEN
			RAISE EXCEPTION USING HINT = 'Missing rating.';
		END IF;
		
		INSERT INTO tbl_recipes_ratings(
			recipe_id,
			rating,
			comment,
			created_by
		) VALUES (
			p_recipe_id,
			p_rating,
			p_comment,
			p_created_by
		);
		
		RETURN QUERY
			SELECT * FROM tbl_recipes_ratings WHERE recipe_id = p_recipe_id AND created_by = p_created_by;
	END;
$$;
    DROP FUNCTION public.func_recipes_ratings_create(p_recipe_id integer, p_rating integer, p_comment text, p_created_by integer);
       public          postgres    false    228            �           0    0 q   FUNCTION func_recipes_ratings_create(p_recipe_id integer, p_rating integer, p_comment text, p_created_by integer)    ACL     �   GRANT ALL ON FUNCTION public.func_recipes_ratings_create(p_recipe_id integer, p_rating integer, p_comment text, p_created_by integer) TO api;
          public          postgres    false    293            ,           1255    25914 -   func_recipes_togglebookmark(integer, integer)    FUNCTION     z  CREATE FUNCTION public.func_recipes_togglebookmark(p_recipe_id integer, p_created_by integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	DECLARE
		v_bookmarked boolean;
	BEGIN
		IF EXISTS(SELECT from tbl_users_recipes WHERE recipe_id = p_recipe_id AND created_by = p_created_by) THEN
			DELETE FROM 
				tbl_users_recipes 
			WHERE 
				recipe_id = p_recipe_id 
				AND created_by = p_created_by;
				
			v_bookmarked := false;
		ELSE
			INSERT INTO tbl_users_recipes (
				recipe_id,
				created_by
			) VALUES (
				p_recipe_id,
				p_created_by
			);
			
			v_bookmarked := true;
		END IF;
		
		RETURN v_bookmarked;
	END;
$$;
 ]   DROP FUNCTION public.func_recipes_togglebookmark(p_recipe_id integer, p_created_by integer);
       public          postgres    false            �           0    0 O   FUNCTION func_recipes_togglebookmark(p_recipe_id integer, p_created_by integer)    ACL     l   GRANT ALL ON FUNCTION public.func_recipes_togglebookmark(p_recipe_id integer, p_created_by integer) TO api;
          public          postgres    false    300            �            1259    17817    tbl_measurements    TABLE       CREATE TABLE public.tbl_measurements (
    id integer NOT NULL,
    name text NOT NULL,
    standardized integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL,
    type_id integer,
    long_name text
);
 $   DROP TABLE public.tbl_measurements;
       public         heap    postgres    false            �           0    0    TABLE tbl_measurements    ACL     3   GRANT ALL ON TABLE public.tbl_measurements TO api;
          public          postgres    false    210            �            1259    17989    tbl_measurements_types    TABLE     �   CREATE TABLE public.tbl_measurements_types (
    id integer NOT NULL,
    name text NOT NULL,
    standardized_measurement text NOT NULL
);
 *   DROP TABLE public.tbl_measurements_types;
       public         heap    postgres    false            �           0    0    TABLE tbl_measurements_types    ACL     9   GRANT ALL ON TABLE public.tbl_measurements_types TO api;
          public          postgres    false    220            �            1259    25969    tbl_shoppinglist    TABLE     .  CREATE TABLE public.tbl_shoppinglist (
    fooditem_id integer NOT NULL,
    amount integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer,
    checked timestamp without time zone,
    measurement_id integer,
    deleted timestamp without time zone
);
 $   DROP TABLE public.tbl_shoppinglist;
       public         heap    postgres    false            �           0    0    TABLE tbl_shoppinglist    ACL     3   GRANT ALL ON TABLE public.tbl_shoppinglist TO api;
          public          postgres    false    231            �            1259    26001    viw_shoppinglist    VIEW     �  CREATE VIEW public.viw_shoppinglist AS
 SELECT l.fooditem_id,
    l.amount,
    l.created,
    l.created_by,
    l.checked,
    l.measurement_id,
    l.deleted,
    f.name AS fooditem_name,
    m.name AS measurement_name,
    m.standardized AS measurement_standardized,
    mt.id AS measurement_type_id,
    mt.name AS measurement_type_name,
    mt.standardized_measurement,
    (l.amount * m.standardized) AS total_standardized
   FROM (((public.tbl_shoppinglist l
     JOIN public.tbl_fooditems f ON ((l.fooditem_id = f.id)))
     JOIN public.tbl_measurements m ON ((l.measurement_id = m.id)))
     JOIN public.tbl_measurements_types mt ON ((m.type_id = mt.id)));
 #   DROP VIEW public.viw_shoppinglist;
       public          postgres    false    208    231    231    231    231    231    231    231    220    220    220    210    210    210    210    208            �           0    0    TABLE viw_shoppinglist    ACL     3   GRANT ALL ON TABLE public.viw_shoppinglist TO api;
          public          postgres    false    232            �            1259    26025    viw_shoppinglist_aggregated    VIEW     #  CREATE VIEW public.viw_shoppinglist_aggregated AS
 SELECT viw_shoppinglist.fooditem_id,
    viw_shoppinglist.fooditem_name,
    sum(viw_shoppinglist.total_standardized) AS total,
    viw_shoppinglist.standardized_measurement,
    viw_shoppinglist.created_by,
    viw_shoppinglist.checked,
    viw_shoppinglist.deleted
   FROM public.viw_shoppinglist
  GROUP BY viw_shoppinglist.fooditem_id, viw_shoppinglist.fooditem_name, viw_shoppinglist.standardized_measurement, viw_shoppinglist.created_by, viw_shoppinglist.checked, viw_shoppinglist.deleted;
 .   DROP VIEW public.viw_shoppinglist_aggregated;
       public          postgres    false    232    232    232    232    232    232    232            �           0    0 !   TABLE viw_shoppinglist_aggregated    ACL     >   GRANT ALL ON TABLE public.viw_shoppinglist_aggregated TO api;
          public          postgres    false    233            /           1255    26047 $   func_shoppinglist_add(text, integer)    FUNCTION     ;  CREATE FUNCTION public.func_shoppinglist_add(p_items text, p_created_by integer) RETURNS SETOF public.viw_shoppinglist_aggregated
    LANGUAGE plpgsql
    AS $$
	BEGIN
		-- validate input
		IF p_items IS NULL OR char_length(p_items) = 0 THEN
			RAISE EXCEPTION USING HINT = 'Missing shopping list data.';
		END IF;
		
		-- if user has any of the items in shopping list that are already checked -> delete them
		WITH items AS (
			SELECT
				i.fooditem_id,
				i.amount,
				i.measurement_id,
				p_created_by
			FROM
				json_to_recordset(p_items::json) AS i (
					fooditem_id integer,
					amount integer,
					measurement_id integer)
		)
		UPDATE 
			tbl_shoppinglist
		SET 
			deleted = now()
		WHERE 
			checked IS NOT NULL
			AND fooditem_id IN (SELECT fooditem_id FROM items)
			AND created_by = p_created_by;
		
		-- insert new items 
		INSERT INTO tbl_shoppinglist (
			fooditem_id,
			amount,
			measurement_id,
			created_by
		)
		SELECT
			i.fooditem_id,
			i.amount,
			i.measurement_id,
			p_created_by
		FROM
			json_to_recordset(p_items::json) AS i (
				fooditem_id integer,
				amount integer,
				measurement_id integer
			);
			
		-- return users updated shopping list
		RETURN QUERY
			SELECT * FROM viw_shoppinglist_aggregated WHERE created_by = p_created_by AND deleted IS NULL ORDER BY fooditem_name ASC;
	END;
$$;
 P   DROP FUNCTION public.func_shoppinglist_add(p_items text, p_created_by integer);
       public          postgres    false    233            �           0    0 B   FUNCTION func_shoppinglist_add(p_items text, p_created_by integer)    ACL     _   GRANT ALL ON FUNCTION public.func_shoppinglist_add(p_items text, p_created_by integer) TO api;
          public          postgres    false    303            -           1255    26043 2   func_shoppinglist_check(boolean, integer, integer)    FUNCTION       CREATE FUNCTION public.func_shoppinglist_check(p_check boolean, p_fooditem_id integer, p_created_by integer) RETURNS SETOF public.viw_shoppinglist_aggregated
    LANGUAGE plpgsql
    AS $$
	BEGIN
		UPDATE 
			tbl_shoppinglist
		SET
			checked = CASE
				WHEN p_check = true THEN now()
				ELSE NULL
			END
		WHERE
			fooditem_id = p_fooditem_id
			AND created_by = p_created_by;
			
		RETURN QUERY
			SELECT * FROM viw_shoppinglist_aggregated WHERE created_by = p_created_by AND deleted IS NULL ORDER BY fooditem_name ASC;
		
	END;
$$;
 l   DROP FUNCTION public.func_shoppinglist_check(p_check boolean, p_fooditem_id integer, p_created_by integer);
       public          postgres    false    233            �           0    0 ^   FUNCTION func_shoppinglist_check(p_check boolean, p_fooditem_id integer, p_created_by integer)    ACL     {   GRANT ALL ON FUNCTION public.func_shoppinglist_check(p_check boolean, p_fooditem_id integer, p_created_by integer) TO api;
          public          postgres    false    301            .           1255    26049 *   func_shoppinglist_delete(boolean, integer)    FUNCTION     �  CREATE FUNCTION public.func_shoppinglist_delete(p_all boolean, p_created_by integer) RETURNS SETOF public.viw_shoppinglist_aggregated
    LANGUAGE plpgsql
    AS $$
	BEGIN
		-- validate input
		IF p_all IS NULL THEN
			RAISE EXCEPTION USING HINT = 'ALl/checked argument missing.';
		END IF;
		
		-- delete data
		IF p_all = true THEN
			UPDATE 
				tbl_shoppinglist
			SET
				deleted = now()
			WHERE
				created_by = p_created_by;
		ELSE
			UPDATE 
				tbl_shoppinglist
			SET
				deleted = now()
			WHERE
				created_by = p_created_by
				AND checked IS NOT NULL;
		END IF;

		
		-- return updated shopping list
		RETURN QUERY
			SELECT * FROM viw_shoppinglist_aggregated WHERE created_by = p_created_by AND deleted IS NULL ORDER BY fooditem_name ASC;
	END;
$$;
 T   DROP FUNCTION public.func_shoppinglist_delete(p_all boolean, p_created_by integer);
       public          postgres    false    233            �           0    0 F   FUNCTION func_shoppinglist_delete(p_all boolean, p_created_by integer)    ACL     c   GRANT ALL ON FUNCTION public.func_shoppinglist_delete(p_all boolean, p_created_by integer) TO api;
          public          postgres    false    302            �            1259    17732 	   tbl_users    TABLE     �   CREATE TABLE public.tbl_users (
    id integer NOT NULL,
    email text NOT NULL,
    name text NOT NULL,
    password text NOT NULL
);
    DROP TABLE public.tbl_users;
       public         heap    postgres    false            �           0    0    TABLE tbl_users    ACL     ,   GRANT ALL ON TABLE public.tbl_users TO api;
          public          postgres    false    205            �            1259    17791 	   viw_users    VIEW     x   CREATE VIEW public.viw_users AS
 SELECT tbl_users.id,
    tbl_users.email,
    tbl_users.name
   FROM public.tbl_users;
    DROP VIEW public.viw_users;
       public          postgres    false    205    205    205            �           0    0    TABLE viw_users    ACL     ,   GRANT ALL ON TABLE public.viw_users TO api;
          public          postgres    false    206            &           1255    18136 )   func_users_create(text, text, text, text)    FUNCTION     -  CREATE FUNCTION public.func_users_create(p_email text, p_name text, p_password text, p_repeat_password text) RETURNS SETOF public.viw_users
    LANGUAGE plpgsql
    AS $$
	DECLARE
		v_new_user_id integer;
	BEGIN
		IF p_email IS NULL OR CHAR_LENGTH(p_email) = 0 THEN
			RAISE EXCEPTION USING HINT = 'Missing email.';
		END IF;
		
		IF p_name IS NULL OR CHAR_LENGTH(p_name) = 0 THEN
			RAISE EXCEPTION USING HINT = 'Missing name.';
		END IF;
		
		IF p_password IS NULL OR CHAR_LENGTH(p_password) = 0 THEN
			RAISE EXCEPTION USING HINT = 'Missing password.';
		END IF;
		
		IF p_password <> p_repeat_password THEN 
			RAISE EXCEPTION USING HINT = 'Passwords do not match.';
		END IF;
		
		IF EXISTS(SELECT id FROM tbl_users WHERE email = p_email) THEN
			RAISE EXCEPTION USING HINT = 'Email is already in use.';
		END IF;
		
		INSERT INTO tbl_users(
			email,
			name,
			password
		) VALUES (
			p_email,
			p_name,
			crypt(p_password, gen_salt('bf'))
		) RETURNING id INTO v_new_user_id;
		
		RETURN QUERY
			SELECT * FROM viw_users WHERE id = v_new_user_id;
	END;
$$;
 l   DROP FUNCTION public.func_users_create(p_email text, p_name text, p_password text, p_repeat_password text);
       public          postgres    false    206            �           0    0 ^   FUNCTION func_users_create(p_email text, p_name text, p_password text, p_repeat_password text)    ACL     {   GRANT ALL ON FUNCTION public.func_users_create(p_email text, p_name text, p_password text, p_repeat_password text) TO api;
          public          postgres    false    294            (           1255    18113    func_users_exists(text)    FUNCTION     �   CREATE FUNCTION public.func_users_exists(p_email text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN EXISTS(SELECT email FROM tbl_users WHERE email = p_email);
	END;
$$;
 6   DROP FUNCTION public.func_users_exists(p_email text);
       public          postgres    false            �           0    0 (   FUNCTION func_users_exists(p_email text)    ACL     E   GRANT ALL ON FUNCTION public.func_users_exists(p_email text) TO api;
          public          postgres    false    296            )           1255    18114    func_users_login(text, text)    FUNCTION     �  CREATE FUNCTION public.func_users_login(p_email text, p_password text) RETURNS SETOF public.viw_users
    LANGUAGE plpgsql
    AS $$
	DECLARE
		v_user_id integer;
	BEGIN
		SELECT
			id
		INTO
			v_user_id
		FROM
			tbl_users
		WHERE
			email = p_email
			AND password = crypt(p_password, password);
			
		IF v_user_id IS NULL THEN
			RAISE EXCEPTION USING HINT = 'Invalid credentials.';
		ELSE
			RETURN QUERY
				SELECT * FROM viw_users WHERE id = v_user_id;
		END IF;
	END;
$$;
 F   DROP FUNCTION public.func_users_login(p_email text, p_password text);
       public          postgres    false    206            �           0    0 8   FUNCTION func_users_login(p_email text, p_password text)    ACL     U   GRANT ALL ON FUNCTION public.func_users_login(p_email text, p_password text) TO api;
          public          postgres    false    297            �            1259    18116    tbl_defaults    TABLE     F   CREATE TABLE public.tbl_defaults (
    default_measurement integer
);
     DROP TABLE public.tbl_defaults;
       public         heap    postgres    false            �            1259    18093    tbl_files_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.tbl_files_id_seq;
       public          postgres    false    226            �           0    0    tbl_files_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.tbl_files_id_seq OWNED BY public.tbl_files.id;
          public          postgres    false    225            �           0    0    SEQUENCE tbl_files_id_seq    ACL     ?   GRANT SELECT,USAGE ON SEQUENCE public.tbl_files_id_seq TO api;
          public          postgres    false    225            �            1259    17798    tbl_fooditems_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_fooditems_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.tbl_fooditems_id_seq;
       public          postgres    false    208            �           0    0    tbl_fooditems_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.tbl_fooditems_id_seq OWNED BY public.tbl_fooditems.id;
          public          postgres    false    207            �           0    0    SEQUENCE tbl_fooditems_id_seq    ACL     C   GRANT SELECT,USAGE ON SEQUENCE public.tbl_fooditems_id_seq TO api;
          public          postgres    false    207            �            1259    17865    tbl_mealplans_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_mealplans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.tbl_mealplans_id_seq;
       public          postgres    false    215            �           0    0    tbl_mealplans_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.tbl_mealplans_id_seq OWNED BY public.tbl_mealplans.id;
          public          postgres    false    214            �           0    0    SEQUENCE tbl_mealplans_id_seq    ACL     C   GRANT SELECT,USAGE ON SEQUENCE public.tbl_mealplans_id_seq TO api;
          public          postgres    false    214            �            1259    17916    tbl_mealplans_recipes    TABLE     �   CREATE TABLE public.tbl_mealplans_recipes (
    mealplan_id integer NOT NULL,
    recipe_id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL,
    id integer NOT NULL
);
 )   DROP TABLE public.tbl_mealplans_recipes;
       public         heap    postgres    false            �           0    0    TABLE tbl_mealplans_recipes    ACL     8   GRANT ALL ON TABLE public.tbl_mealplans_recipes TO api;
          public          postgres    false    217            �            1259    26053    tbl_mealplans_recipes_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_mealplans_recipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.tbl_mealplans_recipes_id_seq;
       public          postgres    false    217            �           0    0    tbl_mealplans_recipes_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.tbl_mealplans_recipes_id_seq OWNED BY public.tbl_mealplans_recipes.id;
          public          postgres    false    234            �           0    0 %   SEQUENCE tbl_mealplans_recipes_id_seq    ACL     K   GRANT SELECT,USAGE ON SEQUENCE public.tbl_mealplans_recipes_id_seq TO api;
          public          postgres    false    234            �            1259    17815    tbl_measurements_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_measurements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.tbl_measurements_id_seq;
       public          postgres    false    210            �           0    0    tbl_measurements_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.tbl_measurements_id_seq OWNED BY public.tbl_measurements.id;
          public          postgres    false    209            �           0    0     SEQUENCE tbl_measurements_id_seq    ACL     F   GRANT SELECT,USAGE ON SEQUENCE public.tbl_measurements_id_seq TO api;
          public          postgres    false    209            �            1259    17987    tbl_measurements_types_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_measurements_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.tbl_measurements_types_id_seq;
       public          postgres    false    220            �           0    0    tbl_measurements_types_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.tbl_measurements_types_id_seq OWNED BY public.tbl_measurements_types.id;
          public          postgres    false    219            �           0    0 &   SEQUENCE tbl_measurements_types_id_seq    ACL     L   GRANT SELECT,USAGE ON SEQUENCE public.tbl_measurements_types_id_seq TO api;
          public          postgres    false    219            �            1259    17832    tbl_recipes_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_recipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.tbl_recipes_id_seq;
       public          postgres    false    212            �           0    0    tbl_recipes_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.tbl_recipes_id_seq OWNED BY public.tbl_recipes.id;
          public          postgres    false    211            �           0    0    SEQUENCE tbl_recipes_id_seq    ACL     A   GRANT SELECT,USAGE ON SEQUENCE public.tbl_recipes_id_seq TO api;
          public          postgres    false    211            �            1259    17961    tbl_recipes_ingredients    TABLE       CREATE TABLE public.tbl_recipes_ingredients (
    recipe_id integer NOT NULL,
    fooditem_id integer NOT NULL,
    measurement_id integer NOT NULL,
    amount integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL
);
 +   DROP TABLE public.tbl_recipes_ingredients;
       public         heap    postgres    false            �           0    0    TABLE tbl_recipes_ingredients    ACL     :   GRANT ALL ON TABLE public.tbl_recipes_ingredients TO api;
          public          postgres    false    218            �            1259    18006    tbl_recipes_instructions    TABLE       CREATE TABLE public.tbl_recipes_instructions (
    id integer NOT NULL,
    recipe_id integer NOT NULL,
    number integer NOT NULL,
    instruction text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL
);
 ,   DROP TABLE public.tbl_recipes_instructions;
       public         heap    postgres    false            �           0    0    TABLE tbl_recipes_instructions    ACL     ;   GRANT ALL ON TABLE public.tbl_recipes_instructions TO api;
          public          postgres    false    222            �            1259    18004    tbl_recipes_instructions_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_recipes_instructions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.tbl_recipes_instructions_id_seq;
       public          postgres    false    222            �           0    0    tbl_recipes_instructions_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.tbl_recipes_instructions_id_seq OWNED BY public.tbl_recipes_instructions.id;
          public          postgres    false    221            �           0    0 (   SEQUENCE tbl_recipes_instructions_id_seq    ACL     N   GRANT SELECT,USAGE ON SEQUENCE public.tbl_recipes_instructions_id_seq TO api;
          public          postgres    false    221            �            1259    17730    tbl_users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tbl_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.tbl_users_id_seq;
       public          postgres    false    205            �           0    0    tbl_users_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.tbl_users_id_seq OWNED BY public.tbl_users.id;
          public          postgres    false    204            �           0    0    SEQUENCE tbl_users_id_seq    ACL     ?   GRANT SELECT,USAGE ON SEQUENCE public.tbl_users_id_seq TO api;
          public          postgres    false    204            �            1259    17883    tbl_users_mealplans    TABLE     �   CREATE TABLE public.tbl_users_mealplans (
    mealplan_id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL
);
 '   DROP TABLE public.tbl_users_mealplans;
       public         heap    postgres    false            �           0    0    TABLE tbl_users_mealplans    ACL     6   GRANT ALL ON TABLE public.tbl_users_mealplans TO api;
          public          postgres    false    216            �            1259    17849    tbl_users_recipes    TABLE     �   CREATE TABLE public.tbl_users_recipes (
    recipe_id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL
);
 %   DROP TABLE public.tbl_users_recipes;
       public         heap    postgres    false            �           0    0    TABLE tbl_users_recipes    ACL     4   GRANT ALL ON TABLE public.tbl_users_recipes TO api;
          public          postgres    false    213            �            1259    25945    viw_recipes    VIEW     *  CREATE VIEW public.viw_recipes AS
 WITH ratings AS (
         SELECT tbl_recipes_ratings.recipe_id,
            round(avg(tbl_recipes_ratings.rating), 1) AS rating,
            count(tbl_recipes_ratings.recipe_id) AS number_of_ratings
           FROM public.tbl_recipes_ratings
          GROUP BY tbl_recipes_ratings.recipe_id
        ), saves AS (
         SELECT ur.recipe_id,
            count(ur.recipe_id) AS saves
           FROM public.tbl_users_recipes ur
          GROUP BY ur.recipe_id
        ), num_of_ingredients AS (
         SELECT i.recipe_id,
            count(i.fooditem_id) AS num_of_ingredients
           FROM public.tbl_recipes_ingredients i
          GROUP BY i.recipe_id
        )
 SELECT r.id,
    r.name,
    r.description,
    r.cooking_time,
    r.portions,
    r.vegan,
    r.vegetarian,
    r.gluten_free,
    r.allergen_milk,
    r.allergen_egg,
    r.allergen_nuts,
    r.allergen_wheat,
    r.allergen_soy,
    r.allergen_fish,
    r.allergen_shellfish,
    r.created,
    date_part('epoch'::text, r.created) AS created_epoch,
    u.name AS created_by,
    f.id AS file_id,
    f.name AS file_name,
    f.mimetype AS file_type,
    (COALESCE(ratings.rating, (0)::numeric))::double precision AS rating,
    (COALESCE(ratings.number_of_ratings, (0)::bigint))::double precision AS number_of_ratings,
    (COALESCE(saves.saves, (0)::bigint))::double precision AS saves,
    (COALESCE(num_of_ingredients.num_of_ingredients, (0)::bigint))::integer AS num_of_ingredients
   FROM (((((public.tbl_recipes r
     JOIN public.tbl_users u ON ((r.created_by = u.id)))
     LEFT JOIN public.tbl_files f ON ((r.file_id = f.id)))
     LEFT JOIN ratings ON ((r.id = ratings.recipe_id)))
     LEFT JOIN saves ON ((r.id = saves.recipe_id)))
     LEFT JOIN num_of_ingredients ON ((r.id = num_of_ingredients.recipe_id)));
    DROP VIEW public.viw_recipes;
       public          postgres    false    213    218    218    226    226    226    228    228    205    205    212    212    212    212    212    212    212    212    212    212    212    212    212    212    212    212    212    212            �           0    0    TABLE viw_recipes    ACL     .   GRANT ALL ON TABLE public.viw_recipes TO api;
          public          postgres    false    229            �            1259    18084    viw_recipes_ingredients    VIEW     �  CREATE VIEW public.viw_recipes_ingredients AS
 SELECT r.id AS recipe_id,
    r.name AS recipe_name,
    f.id AS fooditem_id,
    f.name AS fooditem_name,
    m.id AS measurement_id,
    m.name AS measurement_name,
    m.long_name AS measurement_long_name,
    m.standardized,
    mt.name,
    mt.standardized_measurement,
    i.amount,
    i.created,
    u.name AS created_by
   FROM (((((public.tbl_recipes_ingredients i
     JOIN public.tbl_measurements m ON ((i.measurement_id = m.id)))
     JOIN public.tbl_fooditems f ON ((i.fooditem_id = f.id)))
     JOIN public.tbl_recipes r ON ((i.recipe_id = r.id)))
     JOIN public.tbl_users u ON ((i.created_by = u.id)))
     JOIN public.tbl_measurements_types mt ON ((m.type_id = mt.id)));
 *   DROP VIEW public.viw_recipes_ingredients;
       public          postgres    false    218    218    212    212    210    210    210    210    210    208    208    205    205    220    220    218    220    218    218    218            �           0    0    TABLE viw_recipes_ingredients    ACL     :   GRANT ALL ON TABLE public.viw_recipes_ingredients TO api;
          public          postgres    false    223            �            1259    18089    viw_recipes_instructions    VIEW     C  CREATE VIEW public.viw_recipes_instructions AS
 SELECT i.id,
    i.recipe_id,
    r.name AS recipe_name,
    i.number,
    i.instruction,
    u.name AS created_by
   FROM ((public.tbl_recipes_instructions i
     JOIN public.tbl_recipes r ON ((i.recipe_id = r.id)))
     JOIN public.tbl_users u ON ((i.created_by = u.id)));
 +   DROP VIEW public.viw_recipes_instructions;
       public          postgres    false    222    222    222    222    222    212    212    205    205            �           0    0    TABLE viw_recipes_instructions    ACL     ;   GRANT ALL ON TABLE public.viw_recipes_instructions TO api;
          public          postgres    false    224            �            1259    25959    viw_recipes_ratings    VIEW     ,  CREATE VIEW public.viw_recipes_ratings AS
 SELECT r.recipe_id,
    r.rating,
    r.comment,
    r.created,
    r.created_by,
    date_part('epoch'::text, r.created) AS created_epoch,
    u.name AS author
   FROM (public.tbl_recipes_ratings r
     JOIN public.tbl_users u ON ((r.created_by = u.id)));
 &   DROP VIEW public.viw_recipes_ratings;
       public          postgres    false    205    205    228    228    228    228    228            �           0    0    TABLE viw_recipes_ratings    ACL     6   GRANT ALL ON TABLE public.viw_recipes_ratings TO api;
          public          postgres    false    230            �           2604    18098    tbl_files id    DEFAULT     l   ALTER TABLE ONLY public.tbl_files ALTER COLUMN id SET DEFAULT nextval('public.tbl_files_id_seq'::regclass);
 ;   ALTER TABLE public.tbl_files ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    225    226    226            �           2604    17803    tbl_fooditems id    DEFAULT     t   ALTER TABLE ONLY public.tbl_fooditems ALTER COLUMN id SET DEFAULT nextval('public.tbl_fooditems_id_seq'::regclass);
 ?   ALTER TABLE public.tbl_fooditems ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    208    207    208            �           2604    17870    tbl_mealplans id    DEFAULT     t   ALTER TABLE ONLY public.tbl_mealplans ALTER COLUMN id SET DEFAULT nextval('public.tbl_mealplans_id_seq'::regclass);
 ?   ALTER TABLE public.tbl_mealplans ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    214    215    215            �           2604    26055    tbl_mealplans_recipes id    DEFAULT     �   ALTER TABLE ONLY public.tbl_mealplans_recipes ALTER COLUMN id SET DEFAULT nextval('public.tbl_mealplans_recipes_id_seq'::regclass);
 G   ALTER TABLE public.tbl_mealplans_recipes ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    234    217            �           2604    17820    tbl_measurements id    DEFAULT     z   ALTER TABLE ONLY public.tbl_measurements ALTER COLUMN id SET DEFAULT nextval('public.tbl_measurements_id_seq'::regclass);
 B   ALTER TABLE public.tbl_measurements ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    210    209    210            �           2604    17992    tbl_measurements_types id    DEFAULT     �   ALTER TABLE ONLY public.tbl_measurements_types ALTER COLUMN id SET DEFAULT nextval('public.tbl_measurements_types_id_seq'::regclass);
 H   ALTER TABLE public.tbl_measurements_types ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219    220            �           2604    17837    tbl_recipes id    DEFAULT     p   ALTER TABLE ONLY public.tbl_recipes ALTER COLUMN id SET DEFAULT nextval('public.tbl_recipes_id_seq'::regclass);
 =   ALTER TABLE public.tbl_recipes ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    211    212    212            �           2604    18009    tbl_recipes_instructions id    DEFAULT     �   ALTER TABLE ONLY public.tbl_recipes_instructions ALTER COLUMN id SET DEFAULT nextval('public.tbl_recipes_instructions_id_seq'::regclass);
 J   ALTER TABLE public.tbl_recipes_instructions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    221    222    222            �           2604    17735    tbl_users id    DEFAULT     l   ALTER TABLE ONLY public.tbl_users ALTER COLUMN id SET DEFAULT nextval('public.tbl_users_id_seq'::regclass);
 ;   ALTER TABLE public.tbl_users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    204    205    205            �          0    18116    tbl_defaults 
   TABLE DATA           ;   COPY public.tbl_defaults (default_measurement) FROM stdin;
    public          postgres    false    227   �      �          0    18095 	   tbl_files 
   TABLE DATA           R   COPY public.tbl_files (id, name, size, mimetype, created, created_by) FROM stdin;
    public          postgres    false    226   �      �          0    17800    tbl_fooditems 
   TABLE DATA           ]   COPY public.tbl_fooditems (id, name, created, created_by, reviewed, reviewed_by) FROM stdin;
    public          postgres    false    208         �          0    17867    tbl_mealplans 
   TABLE DATA           [   COPY public.tbl_mealplans (id, name, description, public, created, created_by) FROM stdin;
    public          postgres    false    215   &      �          0    17916    tbl_mealplans_recipes 
   TABLE DATA           `   COPY public.tbl_mealplans_recipes (mealplan_id, recipe_id, created, created_by, id) FROM stdin;
    public          postgres    false    217   o      �          0    17817    tbl_measurements 
   TABLE DATA           k   COPY public.tbl_measurements (id, name, standardized, created, created_by, type_id, long_name) FROM stdin;
    public          postgres    false    210   �      �          0    17989    tbl_measurements_types 
   TABLE DATA           T   COPY public.tbl_measurements_types (id, name, standardized_measurement) FROM stdin;
    public          postgres    false    220   �      �          0    17834    tbl_recipes 
   TABLE DATA             COPY public.tbl_recipes (id, name, description, created, created_by, cooking_time, portions, file_id, vegan, vegetarian, gluten_free, allergen_milk, allergen_egg, allergen_nuts, allergen_wheat, allergen_soy, allergen_fish, allergen_shellfish, reviewed, reviewed_by) FROM stdin;
    public          postgres    false    212   �      �          0    17961    tbl_recipes_ingredients 
   TABLE DATA           v   COPY public.tbl_recipes_ingredients (recipe_id, fooditem_id, measurement_id, amount, created, created_by) FROM stdin;
    public          postgres    false    218   �       �          0    18006    tbl_recipes_instructions 
   TABLE DATA           k   COPY public.tbl_recipes_instructions (id, recipe_id, number, instruction, created, created_by) FROM stdin;
    public          postgres    false    222   �!      �          0    18161    tbl_recipes_ratings 
   TABLE DATA           ^   COPY public.tbl_recipes_ratings (recipe_id, rating, comment, created, created_by) FROM stdin;
    public          postgres    false    228   �$      �          0    25969    tbl_shoppinglist 
   TABLE DATA           v   COPY public.tbl_shoppinglist (fooditem_id, amount, created, created_by, checked, measurement_id, deleted) FROM stdin;
    public          postgres    false    231   p%      �          0    17732 	   tbl_users 
   TABLE DATA           >   COPY public.tbl_users (id, email, name, password) FROM stdin;
    public          postgres    false    205   K.      �          0    17883    tbl_users_mealplans 
   TABLE DATA           O   COPY public.tbl_users_mealplans (mealplan_id, created, created_by) FROM stdin;
    public          postgres    false    216   �/      �          0    17849    tbl_users_recipes 
   TABLE DATA           K   COPY public.tbl_users_recipes (recipe_id, created, created_by) FROM stdin;
    public          postgres    false    213   �/      �           0    0    tbl_files_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.tbl_files_id_seq', 109, true);
          public          postgres    false    225            �           0    0    tbl_fooditems_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.tbl_fooditems_id_seq', 1510, true);
          public          postgres    false    207            �           0    0    tbl_mealplans_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.tbl_mealplans_id_seq', 9, true);
          public          postgres    false    214            �           0    0    tbl_mealplans_recipes_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.tbl_mealplans_recipes_id_seq', 17, true);
          public          postgres    false    234            �           0    0    tbl_measurements_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.tbl_measurements_id_seq', 24, true);
          public          postgres    false    209            �           0    0    tbl_measurements_types_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.tbl_measurements_types_id_seq', 4, true);
          public          postgres    false    219            �           0    0    tbl_recipes_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.tbl_recipes_id_seq', 36, true);
          public          postgres    false    211            �           0    0    tbl_recipes_instructions_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.tbl_recipes_instructions_id_seq', 42, true);
          public          postgres    false    221            �           0    0    tbl_users_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.tbl_users_id_seq', 11, true);
          public          postgres    false    204            �           2606    18109    tbl_files pk_tbl_files 
   CONSTRAINT     T   ALTER TABLE ONLY public.tbl_files
    ADD CONSTRAINT pk_tbl_files PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.tbl_files DROP CONSTRAINT pk_tbl_files;
       public            postgres    false    226            �           2606    17809    tbl_fooditems pk_tbl_fooditems 
   CONSTRAINT     \   ALTER TABLE ONLY public.tbl_fooditems
    ADD CONSTRAINT pk_tbl_fooditems PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.tbl_fooditems DROP CONSTRAINT pk_tbl_fooditems;
       public            postgres    false    208            �           2606    17877    tbl_mealplans pk_tbl_mealplans 
   CONSTRAINT     \   ALTER TABLE ONLY public.tbl_mealplans
    ADD CONSTRAINT pk_tbl_mealplans PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.tbl_mealplans DROP CONSTRAINT pk_tbl_mealplans;
       public            postgres    false    215            �           2606    26061 .   tbl_mealplans_recipes pk_tbl_mealplans_recipes 
   CONSTRAINT     l   ALTER TABLE ONLY public.tbl_mealplans_recipes
    ADD CONSTRAINT pk_tbl_mealplans_recipes PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.tbl_mealplans_recipes DROP CONSTRAINT pk_tbl_mealplans_recipes;
       public            postgres    false    217            �           2606    17826 $   tbl_measurements pk_tbl_measurements 
   CONSTRAINT     b   ALTER TABLE ONLY public.tbl_measurements
    ADD CONSTRAINT pk_tbl_measurements PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.tbl_measurements DROP CONSTRAINT pk_tbl_measurements;
       public            postgres    false    210            �           2606    17997 0   tbl_measurements_types pk_tbl_measurements_types 
   CONSTRAINT     n   ALTER TABLE ONLY public.tbl_measurements_types
    ADD CONSTRAINT pk_tbl_measurements_types PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.tbl_measurements_types DROP CONSTRAINT pk_tbl_measurements_types;
       public            postgres    false    220            �           2606    17843    tbl_recipes pk_tbl_recipes 
   CONSTRAINT     X   ALTER TABLE ONLY public.tbl_recipes
    ADD CONSTRAINT pk_tbl_recipes PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.tbl_recipes DROP CONSTRAINT pk_tbl_recipes;
       public            postgres    false    212            �           2606    17986 2   tbl_recipes_ingredients pk_tbl_recipes_ingredients 
   CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes_ingredients
    ADD CONSTRAINT pk_tbl_recipes_ingredients PRIMARY KEY (recipe_id, fooditem_id);
 \   ALTER TABLE ONLY public.tbl_recipes_ingredients DROP CONSTRAINT pk_tbl_recipes_ingredients;
       public            postgres    false    218    218            �           2606    17740    tbl_users pk_tbl_users 
   CONSTRAINT     T   ALTER TABLE ONLY public.tbl_users
    ADD CONSTRAINT pk_tbl_users PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.tbl_users DROP CONSTRAINT pk_tbl_users;
       public            postgres    false    205            �           2606    17898 *   tbl_users_mealplans pk_tbl_users_mealplans 
   CONSTRAINT     }   ALTER TABLE ONLY public.tbl_users_mealplans
    ADD CONSTRAINT pk_tbl_users_mealplans PRIMARY KEY (mealplan_id, created_by);
 T   ALTER TABLE ONLY public.tbl_users_mealplans DROP CONSTRAINT pk_tbl_users_mealplans;
       public            postgres    false    216    216            �           2606    17864 &   tbl_users_recipes pk_tbl_users_recipes 
   CONSTRAINT     w   ALTER TABLE ONLY public.tbl_users_recipes
    ADD CONSTRAINT pk_tbl_users_recipes PRIMARY KEY (recipe_id, created_by);
 P   ALTER TABLE ONLY public.tbl_users_recipes DROP CONSTRAINT pk_tbl_users_recipes;
       public            postgres    false    213    213            �           2606    17742     tbl_users unique_tbl_users_email 
   CONSTRAINT     \   ALTER TABLE ONLY public.tbl_users
    ADD CONSTRAINT unique_tbl_users_email UNIQUE (email);
 J   ALTER TABLE ONLY public.tbl_users DROP CONSTRAINT unique_tbl_users_email;
       public            postgres    false    205            	           2606    18103     tbl_files fk_tbl_files_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_files
    ADD CONSTRAINT fk_tbl_files_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 J   ALTER TABLE ONLY public.tbl_files DROP CONSTRAINT fk_tbl_files_tbl_users;
       public          postgres    false    205    226    3037            �           2606    18156 4   tbl_fooditems fk_tbl_fooditems_reviewed_by_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_fooditems
    ADD CONSTRAINT fk_tbl_fooditems_reviewed_by_tbl_users FOREIGN KEY (reviewed_by) REFERENCES public.tbl_users(id);
 ^   ALTER TABLE ONLY public.tbl_fooditems DROP CONSTRAINT fk_tbl_fooditems_reviewed_by_tbl_users;
       public          postgres    false    3037    208    205            �           2606    17810 (   tbl_fooditems fk_tbl_fooditems_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_fooditems
    ADD CONSTRAINT fk_tbl_fooditems_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 R   ALTER TABLE ONLY public.tbl_fooditems DROP CONSTRAINT fk_tbl_fooditems_tbl_users;
       public          postgres    false    208    3037    205                        2606    17920 <   tbl_mealplans_recipes fk_tbl_mealplans_recipes_tbl_mealplans    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_mealplans_recipes
    ADD CONSTRAINT fk_tbl_mealplans_recipes_tbl_mealplans FOREIGN KEY (mealplan_id) REFERENCES public.tbl_mealplans(id);
 f   ALTER TABLE ONLY public.tbl_mealplans_recipes DROP CONSTRAINT fk_tbl_mealplans_recipes_tbl_mealplans;
       public          postgres    false    217    3049    215                       2606    18066 :   tbl_mealplans_recipes fk_tbl_mealplans_recipes_tbl_recipes    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_mealplans_recipes
    ADD CONSTRAINT fk_tbl_mealplans_recipes_tbl_recipes FOREIGN KEY (recipe_id) REFERENCES public.tbl_recipes(id) ON DELETE CASCADE;
 d   ALTER TABLE ONLY public.tbl_mealplans_recipes DROP CONSTRAINT fk_tbl_mealplans_recipes_tbl_recipes;
       public          postgres    false    212    3045    217                       2606    17930 8   tbl_mealplans_recipes fk_tbl_mealplans_recipes_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_mealplans_recipes
    ADD CONSTRAINT fk_tbl_mealplans_recipes_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 b   ALTER TABLE ONLY public.tbl_mealplans_recipes DROP CONSTRAINT fk_tbl_mealplans_recipes_tbl_users;
       public          postgres    false    205    3037    217            �           2606    17878 (   tbl_mealplans fk_tbl_mealplans_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_mealplans
    ADD CONSTRAINT fk_tbl_mealplans_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 R   ALTER TABLE ONLY public.tbl_mealplans DROP CONSTRAINT fk_tbl_mealplans_tbl_users;
       public          postgres    false    215    205    3037            �           2606    17998 ;   tbl_measurements fk_tbl_measurements_tbl_measurements_types    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_measurements
    ADD CONSTRAINT fk_tbl_measurements_tbl_measurements_types FOREIGN KEY (type_id) REFERENCES public.tbl_measurements_types(id);
 e   ALTER TABLE ONLY public.tbl_measurements DROP CONSTRAINT fk_tbl_measurements_tbl_measurements_types;
       public          postgres    false    220    210    3057            �           2606    17827 .   tbl_measurements fk_tbl_measurements_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_measurements
    ADD CONSTRAINT fk_tbl_measurements_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 X   ALTER TABLE ONLY public.tbl_measurements DROP CONSTRAINT fk_tbl_measurements_tbl_users;
       public          postgres    false    205    210    3037                       2606    17970 @   tbl_recipes_ingredients fk_tbl_recipes_ingredients_tbl_fooditems    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes_ingredients
    ADD CONSTRAINT fk_tbl_recipes_ingredients_tbl_fooditems FOREIGN KEY (fooditem_id) REFERENCES public.tbl_fooditems(id);
 j   ALTER TABLE ONLY public.tbl_recipes_ingredients DROP CONSTRAINT fk_tbl_recipes_ingredients_tbl_fooditems;
       public          postgres    false    3041    218    208                       2606    17975 C   tbl_recipes_ingredients fk_tbl_recipes_ingredients_tbl_measurements    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes_ingredients
    ADD CONSTRAINT fk_tbl_recipes_ingredients_tbl_measurements FOREIGN KEY (measurement_id) REFERENCES public.tbl_measurements(id);
 m   ALTER TABLE ONLY public.tbl_recipes_ingredients DROP CONSTRAINT fk_tbl_recipes_ingredients_tbl_measurements;
       public          postgres    false    210    3043    218                       2606    18051 >   tbl_recipes_ingredients fk_tbl_recipes_ingredients_tbl_recipes    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes_ingredients
    ADD CONSTRAINT fk_tbl_recipes_ingredients_tbl_recipes FOREIGN KEY (recipe_id) REFERENCES public.tbl_recipes(id) ON DELETE CASCADE;
 h   ALTER TABLE ONLY public.tbl_recipes_ingredients DROP CONSTRAINT fk_tbl_recipes_ingredients_tbl_recipes;
       public          postgres    false    218    3045    212                       2606    17980 <   tbl_recipes_ingredients fk_tbl_recipes_ingredients_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes_ingredients
    ADD CONSTRAINT fk_tbl_recipes_ingredients_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 f   ALTER TABLE ONLY public.tbl_recipes_ingredients DROP CONSTRAINT fk_tbl_recipes_ingredients_tbl_users;
       public          postgres    false    3037    218    205                       2606    18056 @   tbl_recipes_instructions fk_tbl_recipes_instructions_tbl_recipes    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes_instructions
    ADD CONSTRAINT fk_tbl_recipes_instructions_tbl_recipes FOREIGN KEY (recipe_id) REFERENCES public.tbl_recipes(id) ON DELETE CASCADE;
 j   ALTER TABLE ONLY public.tbl_recipes_instructions DROP CONSTRAINT fk_tbl_recipes_instructions_tbl_recipes;
       public          postgres    false    3045    212    222                       2606    18019 >   tbl_recipes_instructions fk_tbl_recipes_instructions_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes_instructions
    ADD CONSTRAINT fk_tbl_recipes_instructions_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 h   ALTER TABLE ONLY public.tbl_recipes_instructions DROP CONSTRAINT fk_tbl_recipes_instructions_tbl_users;
       public          postgres    false    205    3037    222                       2606    18189 6   tbl_recipes_ratings fk_tbl_recipes_ratings_tbl_recipes    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes_ratings
    ADD CONSTRAINT fk_tbl_recipes_ratings_tbl_recipes FOREIGN KEY (recipe_id) REFERENCES public.tbl_recipes(id) ON DELETE CASCADE;
 `   ALTER TABLE ONLY public.tbl_recipes_ratings DROP CONSTRAINT fk_tbl_recipes_ratings_tbl_recipes;
       public          postgres    false    212    228    3045            
           2606    18173 4   tbl_recipes_ratings fk_tbl_recipes_ratings_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes_ratings
    ADD CONSTRAINT fk_tbl_recipes_ratings_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 ^   ALTER TABLE ONLY public.tbl_recipes_ratings DROP CONSTRAINT fk_tbl_recipes_ratings_tbl_users;
       public          postgres    false    3037    205    228            �           2606    18151 0   tbl_recipes fk_tbl_recipes_reviewed_by_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes
    ADD CONSTRAINT fk_tbl_recipes_reviewed_by_tbl_users FOREIGN KEY (reviewed_by) REFERENCES public.tbl_users(id);
 Z   ALTER TABLE ONLY public.tbl_recipes DROP CONSTRAINT fk_tbl_recipes_reviewed_by_tbl_users;
       public          postgres    false    205    3037    212            �           2606    18119 $   tbl_recipes fk_tbl_recipes_tbl_files    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes
    ADD CONSTRAINT fk_tbl_recipes_tbl_files FOREIGN KEY (file_id) REFERENCES public.tbl_files(id);
 N   ALTER TABLE ONLY public.tbl_recipes DROP CONSTRAINT fk_tbl_recipes_tbl_files;
       public          postgres    false    3059    226    212            �           2606    17844 $   tbl_recipes fk_tbl_recipes_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_recipes
    ADD CONSTRAINT fk_tbl_recipes_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 N   ALTER TABLE ONLY public.tbl_recipes DROP CONSTRAINT fk_tbl_recipes_tbl_users;
       public          postgres    false    212    205    3037                       2606    25973 2   tbl_shoppinglist fk_tbl_shoppinglist_tbl_fooditems    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_shoppinglist
    ADD CONSTRAINT fk_tbl_shoppinglist_tbl_fooditems FOREIGN KEY (fooditem_id) REFERENCES public.tbl_fooditems(id);
 \   ALTER TABLE ONLY public.tbl_shoppinglist DROP CONSTRAINT fk_tbl_shoppinglist_tbl_fooditems;
       public          postgres    false    231    3041    208                       2606    25988 5   tbl_shoppinglist fk_tbl_shoppinglist_tbl_measurements    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_shoppinglist
    ADD CONSTRAINT fk_tbl_shoppinglist_tbl_measurements FOREIGN KEY (measurement_id) REFERENCES public.tbl_measurements(id);
 _   ALTER TABLE ONLY public.tbl_shoppinglist DROP CONSTRAINT fk_tbl_shoppinglist_tbl_measurements;
       public          postgres    false    3043    231    210                       2606    25983 .   tbl_shoppinglist fk_tbl_shoppinglist_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_shoppinglist
    ADD CONSTRAINT fk_tbl_shoppinglist_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 X   ALTER TABLE ONLY public.tbl_shoppinglist DROP CONSTRAINT fk_tbl_shoppinglist_tbl_users;
       public          postgres    false    205    231    3037            �           2606    17887 8   tbl_users_mealplans fk_tbl_users_mealplans_tbl_mealplans    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_users_mealplans
    ADD CONSTRAINT fk_tbl_users_mealplans_tbl_mealplans FOREIGN KEY (mealplan_id) REFERENCES public.tbl_mealplans(id);
 b   ALTER TABLE ONLY public.tbl_users_mealplans DROP CONSTRAINT fk_tbl_users_mealplans_tbl_mealplans;
       public          postgres    false    3049    216    215            �           2606    17892 4   tbl_users_mealplans fk_tbl_users_mealplans_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_users_mealplans
    ADD CONSTRAINT fk_tbl_users_mealplans_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 ^   ALTER TABLE ONLY public.tbl_users_mealplans DROP CONSTRAINT fk_tbl_users_mealplans_tbl_users;
       public          postgres    false    216    3037    205            �           2606    18061 2   tbl_users_recipes fk_tbl_users_recipes_tbl_recipes    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_users_recipes
    ADD CONSTRAINT fk_tbl_users_recipes_tbl_recipes FOREIGN KEY (recipe_id) REFERENCES public.tbl_recipes(id) ON DELETE CASCADE;
 \   ALTER TABLE ONLY public.tbl_users_recipes DROP CONSTRAINT fk_tbl_users_recipes_tbl_recipes;
       public          postgres    false    212    3045    213            �           2606    17858 0   tbl_users_recipes fk_tbl_users_recipes_tbl_users    FK CONSTRAINT     �   ALTER TABLE ONLY public.tbl_users_recipes
    ADD CONSTRAINT fk_tbl_users_recipes_tbl_users FOREIGN KEY (created_by) REFERENCES public.tbl_users(id);
 Z   ALTER TABLE ONLY public.tbl_users_recipes DROP CONSTRAINT fk_tbl_users_recipes_tbl_users;
       public          postgres    false    213    3037    205            �      x������ � �      �     x��Y�n[9|��"? .�JRo��+0Gv<�؆7y�|�T�q�����0�Iw��U]�C+�Z�*�P5�ޜɉ��MW�^M�}��.�n�ʟ/�+f1Y=|���������\ׄ�@���Q.�Y������q{����t�R�1~F�/��u#��vfʊ:�6nH��6���v�?k�ԆҰ6F����"�m��V�ڀ�3�ϴQ+9ĀaS0xS��n]������gLՇT�Ⱥ�ZX�:۔��F������#g�Jņi�GER+J�@$��C5ы�?yD���i-�v�f�����^F�Jq$G�
��p�[�#Bۦ�Ҕ�F��7&�sKP_�>�����e�� ����GlM[nvJ�)m��N�#t��(;�(�㠼�1e}��
���:D7�E���N��bֱ�V�:Yp<a}fqIM ߡ�,S@چ�Q�F�ST�zH��m�.!T���Y���66䥛H�7������ӧ����5S�;�� }E��"DP���O8!�!����y8�6�T8����>4�%4$۞�U˝L�^���mT���@�Q/�k$Q�2�z A�Z賓2�a%K��k�O�a��S�	�1A��T���2��)L��=�I�0~l��F���SuFuI�;�)�H�D���La<lq�����)�O��N á]:���3�0��t
�cnk8����ag?=<=�~ܾ.�+��֪�Ђ���^�6�o��<�]."��`T��o�aqX��}�6V��:{ͽ���U���c��t�v�'E(�1��ǈ
�)41	���.�� $�6��;9xh�PEY�cl��)�o�(������v���2cS� �"2f���m���<������E��J��z�t8�l��u,�R>��$��(��Ww��r�p�b��gd�����l0\�:8�!�/q��-AfH���1	(/�������*I�4>��p8p�-�F��� Тֵj�'p��éh$��O0�	��Yk���������R5�\(����G'UL¦�<�s#jò���M6>r`�h�]���&hJ��w"i-������Bbb��C�#�Fm�7Y6�6K�'!1�і��r��4����2�,�o� �f��bql��bL��9�����]�֘�m�����W����z^?��e�L(	����o�({��]u˷y4�#����P]��^���ٗqa����V�����X˅_�U��������_^֫k�6	��ޯ5�;�>}��m�z�������)!�����B���a�]�7tY�||�}~y~�k!1tco��Kl6���z1���� �Xg4p���Ǐ�r��a��kz���E���X	`�
< ]��S��A�a6�I���V�P�
Ǖ��p"�ע\!��SO��D�12A�=}΂`���F2�/����q'uo6���ąywV�Ʃg�����6�~��Ɨ�o�X�v�����$>�rm���Ry�M;>���q��XT��n�o��Ϗ�\�u����\���<H[�^A64`���|��>�G\E4"/hw<�3?�}hk������#�!R9����}q���8�h�WY�_Ꮻ����+���si�:�ݝ�J-BOQ	9'�D"��� �WM=N̨_ 0����UOL�7����苉B~��in� �3��$zC�1�����r⹅�LX�^ě/ '~ {�(}"�4��\���{}��>�����e�d���ޘ�$Q�f��w�/��'�G�.��LB	&�W[���;K�0��%�	��jXj1�rvv�7�3d      �     x�m��n�6�������9���:h�(�M�P��Vm!������w��%/�;�<�
����<Wm��W�8T�~��+��hJ$i	?����m�%�}IF��!���C7ġ[���JM���P����O�j! J�o0�E@l���W�-�J圵��Z��N��x��g�P��&�ir��Cu8T}��׸&��z��S�+��hi�Bm.h`����YQP�J��Jt�4���Mw�,����=N,��!���0��P�R�&πb���]¶-�E��%(þ��'�H��)(`�����1���nc��O�� ��<5@b��}���cXRH֬�y��� l����㩍��Q7�N<v/��e�0�Q4�#p�Ap�?���n��W� ��G��0T3'�ǒ3c�z'X��K����.;"qߺ6���� ��J�'qW7�mIZ� >/6o%�M��.�^�Hِ-�+�E�����2�-eI����O�l)7��m�X�I��s8�O��e��a�&n�?=-En��#���9��<���w�M>��x�^��Mƴ!p�|��`\ڣ�tM�S����4�2�gEl�j[|�:�:p�JO)��Ή���/�]<�&.E&�\�.�l3/O/U_o�y�r���Aܷu>2δ!I��e�f����?/`T%�D͝�[	 VO��yW�ɼF^?W�K�5ձ������yy��|u���.��b[��5F�gM)��C�%��p&����g8�v.�9m�}S�����Y*\�CZ�s:W8���_њ��������6�@a~�!������f��:�g���A
ğU��V���ˤ������3^9N������r��uC�׵(�&
F��L�Ū�^�b}��s�,"�H��2���Xwo�D�R�罟�C�{��MQ��@�_73ڊo�-V|��R�ӕp�h�3��c=�%�GPR;���<��]W��OC[�-d�/��f��1�x�)���'���۬7��,�F9����t���������d\>�      �   9   x���t��OQH�1~�i�FF���F&
FFV&FV�zf�F��朦\1z\\\ >s
�      �   I   x����� D�3T�t�H���#Ix��Bh�k�\������@�����R����8)�/��'�      �   �  x���A��0E��)r�
"Eʖn0뢻nǓ
�O�lz��r[l����?���&XΏP��/����(�h5�!@X�s��6���+�2<r��p7xIlj��~�WJp�w�ia,;i��'	6 �Qj�Q��*G������"#�Vs���gM�u0C�ł��t���O>a����@̡2��/��sZۨ�\Ԇ0I>XI�\Xu=|�z�w ��l�K��*��bt�D����]���xvwU�v|{lտm�3QW�j��m��{�J�,���HS��-��O^�k4���y5��.���B���2�-�3��Q.�ƨ�q��Y3���k��P��Y���B��8�״�A-��׫*yֳ"�^�}Z���6N6���/@0�~����bE��qk��=�	H�j���Wq��K�����������[�V��n�1�=��      �   <   x�3�,��)�M����2�,O�L�(�L�2�,�LMN�,H.�2��I�K/��������� ���      �   	  x�]�Ao�0�����[�iI{,��i�N\�4���E!����l��-Y����2�Sr��������-���퀟�+Fg��	PR��.�5�&�L%� .	���w������;S+�����o�_EEuA�Ң�R�%�`��P�*h�7\�@D��.8�6�=��u���\�{F�'��}�b��5��>B�H����J�\W��PN�����Ţ
V��c?���xF;���x��}'�k#��zQ2=��ϰ�>k�e���v�      �   �   x���[n�0�o���@-�������8SUytb��o�F��P'%0�K��K���:��m� (��eGk&�*a~k����dT�/2�%���?*�oC��5���"�3�O��ڎ̍ɀ����WiWw8#�u^��]4P�\�僫>��˶���zSf[H��s]^�C�`��}LO��x�!�%f�}J��1�2���;ݱ�v��\�z�l���Ew�X{��o�N۶� ����      �   �  x��T�r�0<�_�P=������t���K/��Xl(QCRq��/@�i^cuF�Ȳ��X,��"[�L\[� �E�[]?`/d*�/]%d�-]E���M���\dWIq�0Vy5�8SSrM.���7+�mH��"����}�t?�{��4��7`0���so�����w42�륔i���f�4R��θWW?>��}�Ksq����� ���C�ÀthI�Ao��2�L�̨�����'pD�C�LA�����=i3�5!��V�M�k��K���2�t�u�NFy�!X�I���2�d�\|#o;�[p�'�:ݏ=Zm:�@S�<
�s.b���{r+�N�>����$�W��z�L=ǛU��[��
�*ŕ��D�x\;�I��}���m�?���R�����َ8�a0�	8��>?�CcT��n����2t�Ы�ufI
P��L�F���O"��D��pP.p�`��aF�J�i�N�1Nd�r���K�W_AVl�j���:/6�<]�5#Hq}���AܜѸ����$p˃Qu<:~�"��,%�Ѿ���0�w�!T�;B�&���8ґ�Vޣ�U[���)�x;��tm�Q]2	~��%�#/%��PS�]���|�m%Ϙ���ϯZ C���v?Ǜb�쓦�@�W���>O+����Z�&�/�'�$S��z6�����r&X���x��jJC��S:L��T��D>���������/�;��      �   �   x�e���0�W� kto�_RL�$h�ad�%Q	�! `�|�v�Ih���xޗ�g��w�^��ӈ�G�H��z�Χ0���&����<]�q,���~���l��R�S����_L̒��AY �ֱ��r��l9pF�zu�C��:c�5�0      �   �  x��][�)��9�^��UP�����X�=��^D����i!��R���+�����?P�����u��W�����!�9�ɻ�3�����@b4�b`�:|�c�ct���o��m��=�XG��1�?�c���R�!�`�FB�7$�C�V~,���!rC�)�u4�~_c�w xή�ɞ���@0��ه� Ff��¨��`��O����RRyo	�;\=8��_�֮�G�\�/9�6 �_��g��Ƿ���a�a��괨�sߔ1<�B}�>�����oE�W��N&�+س�}OQ༯)4�Ődثp�ƞ��):H������� ���K:��й��,�pD���ɒct�.Z���k|~����/Y�S?+�$_.Ɩ!��ݾ["8�P5 }�Sϫ���Ĉ�xV�Pn���W���y�g�Rhp��#y�,�X��	���mWīH��u�O`J�C�a�E�.'�D�?~
i�E��YkW�x�Ql�&F�������'r���Y����t6Q}�����'9�%}
ǃ�pg��e�������aA=*�|#����&t��s�Ğ�M|��886:h�o�����1vd�8�b-��trϞ�����=3r�4�n�X���C�W#�Y8=��ga(�1�ش��ش�-�����nZ5����{��.����N��gVf��C6���ωL�U�׽�����>:�ճ>�����R'��]`�N���
fUwk�\l}� �oa� �7�Q��e���+O�8^r��N�]'����`�m���D����J���{��
�W�r3@/C4N��d�'�?��V�]Q`_7^���W���L�s�jJ��>���uc"��u���}�U���<��c�����|�R���(L��ρ��z2�1/툄�p�9��Gv�{��я�T]�q���@��S��)�5�m��8�S�1�,'���d���C
t2UGFE�E��4S-^%�w�S�O��G#�o]�	s�a�ĥYڑ�Y_�T33��KIU ��
��4������Yi���u�gb!�֫g��/jD]�Rї1��#`P��yC�-xГ�ƙW�)#\�B�r���:G{��L�Q�zT/���;+���y�ި�}D�E��R�A-�����_��g�U�'
f���g�<'���P���SCy��VZ��Ni�ٛ�=��qT\��&Zl��v��gM�~5�u�7O��8g��=N�0lbȗ��{ ����=~���e�m�I�GMt���-��a��E�ب�} �o6O��c�d��2ϳx{����pJu� ��2C�C9������bc��?5�c� �ʪ����Ov/���3]f��J*�*}��Q+N�;0��~��}> SQ4&��q�E"kDY�<X#�jl�d�FI�=�2����,3�%�,SF�H8{Mt��꼻�{w.�Dw�Z��8a<��6*`S�u{SWz,�(K�b�rWkP�~2���D��]<9�'�YI�pOXk���9.�8��˒����Te�0�&������(x�4� ��H�`�+�]��W]x������hr�pDuC��h54�]��I�h@��L�Y'�-Ms�N�c�u�R<d�D__�B�����
3��iT**�Q�U��U0��~:��ȦE��H葩d����D�E�<1F��kV��Ʃ.�a�d�ʰnRN1��Ⱦʫq�I'Y�1�m���n=6=��ϐ���G̮E0d|�|?_�|��\�P��7���،	69!`y?�jn�W�B�{��)f�wY^bv�m�p���gc��$��(+U��f���c�N�}G���-����rݬQ=�^R�Am���}��é,����-ܛ>;L�1V1�@����eI��8{�25;��7G�2�Wя��~�S�ͷ�=�����Ƿ�'�H�I4C�x\�p�x�GŖ�A�"/3��z���g`��_7=��&�|,�3���&3V?�DNA��o,���|�\7���M�W56ÿ�]i��cӚ��KJu2�]R��^�f�=��LI<��W�Hh������~&K
̈́�zgi���a�e���#)���w��P`L�Xȿ�<���n�(l:M�K&��.���}Gs��ʌ!=�������M�0?҄Gj�oPצ�iO������Iiu�ņ9,~u�0�>��X'��S�τ!��4B�N����y'����[/9�	��i��oA��!WU������D�Y      �   -  x�M�Mr�0 ��p
��XP�YEA�4L7!D$�
�Z��C���jgj������>M"$.��VQ��ER�4�*���cؿ�4���x:�m_\�L�##Ɏ�����Ƽ��l��յ���X�W��3���jN=y.�E�D"�)�q�5�uS��b�C6�>����&ø5pţ��s�k�2�
Ұ�ʣ��O5��k���1�q����V�(�k��=��>��H�%zk�C�� �_�TVI�V,���~˚'����;���_�
/g;���)�A����Pu��u��d��wz�߀,�ߪv�      �   ,   x���4202�54�52Q02�21�25�334277�4����� y�G      �   e   x�U̱�0�Z�B���Hq�?G��N��= ��P|�C��e)����]��b ����ۙ��gq	"����׹�ަ�§6�pF!JS.3E�[z�_�H�     