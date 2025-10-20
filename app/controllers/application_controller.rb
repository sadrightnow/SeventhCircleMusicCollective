class ApplicationController < ActionController::Base
  allow_browser versions: { safari: 15, firefox: 110, ie: 9 }
end