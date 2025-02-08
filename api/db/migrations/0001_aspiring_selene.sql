ALTER TABLE `favorite_trips` ADD `created_at` integer DEFAULT (CURRENT_TIMESTAMP);--> statement-breakpoint
ALTER TABLE `favorite_trips` ADD `updated_at` integer DEFAULT (CURRENT_TIMESTAMP);--> statement-breakpoint
ALTER TABLE `favorite_trips` ADD `deleted_at` integer DEFAULT NULL;