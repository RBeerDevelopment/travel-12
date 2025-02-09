PRAGMA foreign_keys=OFF;--> statement-breakpoint
CREATE TABLE `__new_favorite_trips` (
	`user_id` text NOT NULL,
	`station_id` text NOT NULL,
	`line_id` text NOT NULL,
	`destination_id` text NOT NULL,
	`created_at` integer DEFAULT (CURRENT_TIMESTAMP),
	`updated_at` integer DEFAULT (CURRENT_TIMESTAMP),
	`deleted_at` integer DEFAULT NULL,
	PRIMARY KEY(`user_id`, `station_id`, `line_id`, `destination_id`)
);
--> statement-breakpoint
INSERT INTO `__new_favorite_trips`("user_id", "station_id", "line_id", "destination_id", "created_at", "updated_at", "deleted_at") SELECT "user_id", "station_id", "line_id", "destination_id", "created_at", "updated_at", "deleted_at" FROM `favorite_trips`;--> statement-breakpoint
DROP TABLE `favorite_trips`;--> statement-breakpoint
ALTER TABLE `__new_favorite_trips` RENAME TO `favorite_trips`;--> statement-breakpoint
PRAGMA foreign_keys=ON;