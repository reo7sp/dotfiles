return {
  minuet = {
    -- end_point = 'https://TODO/v1/completions',
    -- api_key = function() return 'TODO' end,
    -- model = 'qwen2.5-coder-32b',
    -- optional = {
    --   max_tokens = 96,
    --   top_p = 0.9,
    --   temperature = 0.2,
    -- },
  },
  codecompanion = {
    -- env = {
    --   url = 'https://TODO',
    --   api_key = 'TODO',
    --   chat_url = '/v1/chat/completions',
    --   models_endpoint = '/v1/models',
    -- },
    -- schema = {
    --   model = {
    --     default = 'qwen2.5-coder-32b',
    --   },
    -- },
    -- temperature = {
    --   order = 2,
    --   mapping = 'parameters',
    --   type = 'number',
    --   optional = true,
    --   default = 0.1,
    --   desc = 'What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.',
    --   validate = function(n)
    --     return n >= 0 and n <= 2, 'Must be between 0 and 2'
    --   end,
    -- },
    -- max_tokens = {
    --   order = 3,
    --   mapping = 'parameters',
    --   type = 'integer',
    --   optional = true,
    --   default = nil,
    --   desc = 'An upper bound for the number of tokens that can be generated for a completion.',
    --   validate = function(n)
    --     return n > 0, 'Must be greater than 0'
    --   end,
    -- },
  },
}
