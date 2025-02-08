CREATE TABLE `favorite_trips` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text,
	`station_id` text,
	`line_id` text,
	`destination_id` text
);
