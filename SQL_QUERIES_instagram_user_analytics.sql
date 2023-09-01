create database ig_clone;
use ig_clone;

# TASK-1 Identify the five oldest users on Instagram from the provided database.

SELECT * FROM users ORDER BY created_at asc LIMIT 5;

#TASK-2  Identify users who have never posted a single photo on Instagram.

select * from users
where id not in
( select user_id from photos);

#TASK-3  Contest Winner Declaration: The team has organized a contest where the user with the most likes on a single photo wins.

SELECT u.id , u.username AS winner_username, p.id AS photo_id, p.image_url , COUNT(l.user_id) AS total_likes FROM users u JOIN photos p ON u.id = p.user_id
JOIN likes l ON p.id = l.photo_id GROUP BY u.id, u.username, p.id, p.image_url
ORDER BY total_likes DESC 
LIMIT 1;

#TASK-4 Hashtag Research: A partner brand wants to know the most popular hashtags to use in their posts to reach the most people.
# Identify and suggest the top five most commonly used hashtags on the platform.

SELECT t.id,t.tag_name, COUNT(*) AS tag_count FROM tags t
JOIN photo_tags pt ON t.id = pt.tag_id
GROUP BY t.tag_name
ORDER BY tag_count DESC
LIMIT 5;

#TASK-5 Determine the day of the week when most users register on Instagram. Provide insights on when to schedule an ad campaign.

SELECT DAYNAME(created_at) AS registration_day, COUNT(*) AS registration_count
FROM users GROUP BY registration_day
ORDER BY registration_count DESC
LIMIT 2;

#TASK-6 User Engagement: Investors want to know if users are still active and posting on Instagram or if they are making fewer posts.
# Calculate the average number of posts per user on Instagram. Also, provide the total number of photos on Instagram divided by the total number of users.

SELECT AVG(posts_per_user) AS avg_posts_per_user,
       (SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) AS photos_per_user_ratio
FROM (
    SELECT user_id, COUNT(*) AS posts_per_user
    FROM photos
    GROUP BY user_id
) AS user_posts;

#TASK-7 Bots & Fake Accounts: Investors want to know if the platform is crowded with fake and dummy accounts.
#Identify users (potential bots) who have liked every single photo on the site, as this is not typically possible for a normal user.

SELECT l.user_id, u.username
FROM users u
JOIN likes l ON u.id = l.user_id
GROUP BY l.user_id, u.username
HAVING COUNT(DISTINCT l.photo_id) 
= (SELECT COUNT(*) FROM photos);








