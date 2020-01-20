Rails.application.config.exception_handler = {
  dev:   nil, # allows you to turn ExceptionHandler "on" in development
  db:    nil, # allocates a "table name" into which exceptions are saved (defaults to nil)
  email: Rails.application.credentials.admin_email # sends exception emails to a listed email (string // "you@email.com")
}
