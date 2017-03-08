default["training"]["container"] = {
		repo: "builder:5000",
		name: "webapp",
		port: "8080",
	}
default["training"]["ports"] = {
		blue: {
			from: "8080",
			to:   "8081",
		},
		green: {
			from: "8081",
			to:   "8080",
		}
	}
