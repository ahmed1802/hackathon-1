-- Language Learning Platform Database Setup
-- Complete SQL Script for database initialization

-- Prevent errors if objects already exist
SET foreign_key_checks = 0;

-- Database creation
DROP DATABASE IF EXISTS language_learning_db;
CREATE DATABASE language_learning_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE language_learning_db;

-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    profile_picture VARCHAR(255) DEFAULT 'default.png',
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME,
    streak_days INT DEFAULT 0,
    xp_points INT DEFAULT 0,
    remember_token VARCHAR(255) DEFAULT NULL,
    user_level ENUM('beginner', 'intermediate', 'advanced') DEFAULT 'beginner',
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_username (username),
    INDEX idx_email (email)
);

-- Languages table
CREATE TABLE languages (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(50) UNIQUE NOT NULL,
    language_code VARCHAR(10) UNIQUE NOT NULL,
    flag_icon VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE
);

-- Levels table
CREATE TABLE levels (
    level_id INT AUTO_INCREMENT PRIMARY KEY,
    language_id INT NOT NULL,
    level_number INT NOT NULL,
    level_name VARCHAR(100) NOT NULL,
    description TEXT,
    xp_required INT DEFAULT 0,
    FOREIGN KEY (language_id) REFERENCES languages(language_id) ON DELETE CASCADE,
    UNIQUE KEY unique_level_per_language (language_id, level_number)
);

-- Lessons table
CREATE TABLE lessons (
    lesson_id INT AUTO_INCREMENT PRIMARY KEY,
    level_id INT NOT NULL,
    lesson_number INT NOT NULL,
    lesson_title VARCHAR(100) NOT NULL,
    lesson_description TEXT,
    estimated_time_minutes INT DEFAULT 10,
    xp_reward INT DEFAULT 10,
    FOREIGN KEY (level_id) REFERENCES levels(level_id) ON DELETE CASCADE,
    UNIQUE KEY unique_lesson_per_level (level_id, lesson_number)
);

-- Exercises table
CREATE TABLE exercises (
    exercise_id INT AUTO_INCREMENT PRIMARY KEY,
    lesson_id INT NOT NULL,
    exercise_type ENUM('multiple_choice', 'fill_blank', 'matching', 'listening', 'speaking', 'writing') NOT NULL,
    question TEXT NOT NULL,
    correct_answer TEXT NOT NULL,
    options JSON,
    difficulty ENUM('easy', 'medium', 'hard') DEFAULT 'medium',
    FOREIGN KEY (lesson_id) REFERENCES lessons(lesson_id) ON DELETE CASCADE
);

-- User progress table
CREATE TABLE user_progress (
    progress_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    language_id INT NOT NULL,
    current_level INT DEFAULT 1,
    completed_lessons INT DEFAULT 0,
    xp_in_language INT DEFAULT 0,
    last_activity DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_favorite BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES languages(language_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_language (user_id, language_id)
);

-- Lesson progress table
CREATE TABLE lesson_progress (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    lesson_id INT NOT NULL,
    completion_status ENUM('not_started', 'in_progress', 'completed') DEFAULT 'not_started',
    completion_date DATETIME,
    score INT DEFAULT 0,
    total_attempts INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(lesson_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_lesson (user_id, lesson_id)
);

-- Activity log table
CREATE TABLE activity_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    activity_type VARCHAR(50) NOT NULL,
    activity_details TEXT,
    xp_earned INT DEFAULT 0,
    activity_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_activity_date (activity_date),
    INDEX idx_user_activity (user_id, activity_type)
);

-- Achievements table
CREATE TABLE achievements (
    achievement_id INT AUTO_INCREMENT PRIMARY KEY,
    achievement_name VARCHAR(100) NOT NULL,
    description TEXT,
    badge_icon VARCHAR(100),
    xp_reward INT DEFAULT 20,
    requirements JSON
);

-- User achievements table
CREATE TABLE user_achievements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    achievement_id INT NOT NULL,
    date_earned DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (achievement_id) REFERENCES achievements(achievement_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_achievement (user_id, achievement_id)
);

-- Daily goals table
CREATE TABLE daily_goals (
    goal_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    target_xp INT DEFAULT 50,
    completed BOOLEAN DEFAULT FALSE,
    date_set DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_daily_goal (user_id, date_set)
);

-- User friends table
CREATE TABLE user_friends (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    status ENUM('pending', 'accepted', 'blocked') DEFAULT 'pending',
    request_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (friend_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_friendship (user_id, friend_id)
);

-- Insert default languages
INSERT INTO languages (language_name, language_code, flag_icon) VALUES
('English', 'en', 'english_flag.png'),
('Spanish', 'es', 'spanish_flag.png'),
('French', 'fr', 'french_flag.png'),
('Italian', 'it', 'italian_flag.png'),
('Dutch', 'nl', 'dutch_flag.png');

-- Insert levels for English
INSERT INTO levels (language_id, level_number, level_name, description, xp_required) VALUES
(1, 1, 'Beginner', 'Basic English phrases and simple conversations', 0),
(1, 2, 'Elementary', 'Simple grammar and everyday vocabulary', 100),
(1, 3, 'Intermediate', 'More complex sentences and broader vocabulary', 300),
(1, 4, 'Advanced', 'Fluent conversations and specialized topics', 600);

-- Insert levels for Spanish
INSERT INTO levels (language_id, level_number, level_name, description, xp_required) VALUES
(2, 1, 'Beginner', 'Basic Spanish phrases and simple conversations', 0),
(2, 2, 'Elementary', 'Simple grammar and everyday vocabulary', 100),
(2, 3, 'Intermediate', 'More complex sentences and broader vocabulary', 300),
(2, 4, 'Advanced', 'Fluent conversations and specialized topics', 600);

-- Insert levels for French
INSERT INTO levels (language_id, level_number, level_name, description, xp_required) VALUES
(3, 1, 'Beginner', 'Basic French phrases and simple conversations', 0),
(3, 2, 'Elementary', 'Simple grammar and everyday vocabulary', 100),
(3, 3, 'Intermediate', 'More complex sentences and broader vocabulary', 300),
(3, 4, 'Advanced', 'Fluent conversations and specialized topics', 600);

-- Insert sample lessons for English Beginner
INSERT INTO lessons (level_id, lesson_number, lesson_title, lesson_description, estimated_time_minutes, xp_reward) VALUES
(1, 1, 'Greetings', 'Learn basic English greetings and introductions', 5, 10),
(1, 2, 'Numbers 1-10', 'Learn to count from one to ten in English', 5, 10),
(1, 3, 'Basic Questions', 'Learn how to ask and answer simple questions', 8, 15);

-- Insert sample exercises
INSERT INTO exercises (lesson_id, exercise_type, question, correct_answer, options, difficulty) VALUES
(1, 'multiple_choice', 'How do you say "hello" in English?', 'Hello', '["Hola", "Bonjour", "Hello", "Ciao"]', 'easy'),
(1, 'fill_blank', 'Good ________, how are you?', 'morning', NULL, 'easy'),
(2, 'multiple_choice', 'What comes after "seven"?', 'eight', '["six", "eight", "nine", "ten"]', 'easy');

-- Insert sample achievements
INSERT INTO achievements (achievement_name, description, badge_icon, xp_reward, requirements) VALUES
('First Steps', 'Complete your first lesson', 'first_steps.png', 20, '{"lessons_completed": 1}'),
('Week Streak', 'Practice for 7 days in a row', 'week_streak.png', 50, '{"streak_days": 7}'),
('Polyglot Novice', 'Start learning 3 different languages', 'polyglot.png', 100, '{"languages_started": 3}');

-- Re-enable foreign key checks
SET foreign_key_checks = 1;

-- End of script message
SELECT 'Database setup complete' AS 'Status';
