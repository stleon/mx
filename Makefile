REBAR       = $(shell pwd)/rebar3
DIALYZER    ?= dialyzer

DIALYZER_WARNINGS = -Wunmatched_returns -Werror_handling \
                    -Wrace_conditions -Wunderspecs

.PHONY: deps compile

all: compile

compile: clean
	@$(REBAR) compile

test: compile
	@$(REBAR) as test eunit skip_deps=true

ct:
	@$(REBAR) skip_deps=true ct

clean:
	@$(REBAR) clean

deps:
	@$(REBAR) deps

build-plt:
	@$(DIALYZER) --build_plt --output_plt .dialyzer_plt \
	    --apps kernel stdlib

dialyze: build-plt
	@$(DIALYZER) --src src --plt .dialyzer_plt $(DIALYZER_WARNINGS)

rel: compile
	$(REBAR) release

release: compile
	$(REBAR) as prod release

run: rel
	$(REBAR) run