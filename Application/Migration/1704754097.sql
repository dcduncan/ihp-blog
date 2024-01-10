ALTER TABLE posts ADD COLUMN user_id UUID NOT NULL;
CREATE INDEX posts_user_id_index ON posts (user_id);
ALTER TABLE posts ADD CONSTRAINT posts_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
