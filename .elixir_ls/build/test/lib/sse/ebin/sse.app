{application,sse,
             [{applications,[kernel,stdlib,elixir,logger,event_bus,plug]},
              {description,"Server Sent Events for Elixir/Plug\n"},
              {modules,['Elixir.SSE','Elixir.SSE.Application',
                        'Elixir.SSE.Chunk','Elixir.SSE.Config',
                        'Elixir.SSE.Server']},
              {registered,[]},
              {vsn,"0.2.1"},
              {extra_applications,[logger]},
              {mod,{'Elixir.SSE.Application',[]}}]}.