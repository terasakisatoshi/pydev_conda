.phony: all, build, test, clean

all: build

build:
	docker build -t pydev-conda .
	docker-compose build

test:
	docker-compose run --rm python bash -c "pytest"

clean:
	rm -rf .ipynb_checkpoints playground/notebooks/.ipynb_checkpoints
	rm -rf .mypy_cache
	rm -rf .pytest_cache
	docker-compose down
