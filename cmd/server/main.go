package main

import (
	"net/http"

	"github.com/a-h/templ"
	"github.com/elishambadi/elimbadi.io/templates"
	"github.com/gin-gonic/gin"
)

func render(c *gin.Context, status int, template templ.Component) error {
	c.Status(status)
	return template.Render(c.Request.Context(), c.Writer)
}

func main() {
	r := gin.Default()

	// Load HTML files from templates folder
	r.Static("/assets", "/app/assets")

	r.SetTrustedProxies(nil)

	// Serve the base HTML
	r.GET("/", func(c *gin.Context) {
		render(c, http.StatusOK, templates.Base())
	})

	// Serve dynamic content for HTMX
	r.GET("/content", func(c *gin.Context) {
		render(c, http.StatusOK, templates.Content())
	})

	// Serve inline edit content for HTMX
	r.GET("/get-item/:id", func(c *gin.Context) {
		id := c.Param("id")
		// Example: generate HTML dynamically based on ID
		render(c, http.StatusOK, templates.GetItem(id))
	})

	// Handle form submission for HTMX
	r.POST("/submit-form", func(c *gin.Context) {
		username := c.PostForm("username")
		response := templates.SubmitForm(username)
		render(c, http.StatusOK, response)
	})

	// Start the server on port 8000
	r.Run(":8000")
}
