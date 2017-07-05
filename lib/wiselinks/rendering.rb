module Wiselinks
  module Rendering

  protected

    def render(*args, &block)
      options = _normalize_args(*args)

      if self.request.wiselinks?
        self.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
        self.headers['Pragma'] = 'no-cache'

        if self.request.wiselinks_partial?
          Wiselinks.log("Processing partial request")
          options[:partial] ||= action_name
        else
          Wiselinks.log("Processing template request")
          if Wiselinks.options[:layout] != false
            options[:layout] = self.wiselinks_layout
          end
        end

        if Wiselinks.options[:assets_digest].present?
          Wiselinks.log("Assets digest #{Wiselinks.options[:assets_digest]}")

          self.headers['X-Wiselinks-Assets-Digest'] = Wiselinks.options[:assets_digest]
        end
      end

      super(options, &block)
    end
  end
end
