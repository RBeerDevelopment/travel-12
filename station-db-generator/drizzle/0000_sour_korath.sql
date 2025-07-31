CREATE TABLE `lines` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`product_id` text,
	FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `products` (
	`id` text PRIMARY KEY NOT NULL,
	`mode` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `station_to_lines` (
	`station_id` text,
	`line_id` text,
	FOREIGN KEY (`station_id`) REFERENCES `stations`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`line_id`) REFERENCES `lines`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `stations` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`normalized_name` text NOT NULL,
	`weight` real NOT NULL,
	`lat` real NOT NULL,
	`lng` real NOT NULL
);
