#!/usr/bin/env nextflow
// hash:sha256:35332458bc03d20d5a5d43c45f3d4319031f9ca90188faff2c59f0649a56da4f

nextflow.enable.dsl = 1

capsule_aind_disrnn_dispatcher_1_to_capsule_aind_disrnn_wrapper_2_1 = channel.create()

// capsule - aind-disrnn-dispatcher
process capsule_aind_disrnn_dispatcher_1 {
	tag 'capsule-7242130'
	container "$REGISTRY_HOST/capsule/3dcc1e97-6f2c-44bc-8b0e-4b715559b4a4"

	cpus 1
	memory '7.5 GB'

	output:
	path 'capsule/results/*' into capsule_aind_disrnn_dispatcher_1_to_capsule_aind_disrnn_wrapper_2_1

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=3dcc1e97-6f2c-44bc-8b0e-4b715559b4a4
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7242130.git" capsule-repo
	else
		git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-7242130.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-disrnn-wrapper
process capsule_aind_disrnn_wrapper_2 {
	tag 'capsule-5421561'
	container "$REGISTRY_HOST/capsule/0d294d22-89c8-463b-821b-9690a18833bd"

	cpus 1
	memory '7.5 GB'

	publishDir "$RESULTS_PATH", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/' from capsule_aind_disrnn_dispatcher_1_to_capsule_aind_disrnn_wrapper_2_1

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=0d294d22-89c8-463b-821b-9690a18833bd
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-5421561.git" capsule-repo
	else
		git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-5421561.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run

	echo "[${task.tag}] completed!"
	"""
}
