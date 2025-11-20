#!/usr/bin/env nextflow
// hash:sha256:2bc0f83a36e8e1c9cce0f07a9478ac0d7ec8b8f8f99ea890c3de745480c6d8dd

// capsule - rachel-aind-disrnn-dispatcher
process capsule_rachel_aind_disrnn_dispatcher_1 {
	tag 'capsule-3092604'
	container "$REGISTRY_HOST/capsule/87a76890-d14e-4f8c-b8c8-4ee0c3ed9910"

	cpus 1
	memory '7.5 GB'

	output:
	path 'capsule/results/*', emit: to_capsule_rachel_aind_disrnn_wrapper_2_1

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=87a76890-d14e-4f8c-b8c8-4ee0c3ed9910
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3092604.git" capsule-repo
	else
		git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-3092604.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_rachel_aind_disrnn_dispatcher_1_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - rachel-aind-disrnn-wrapper
process capsule_rachel_aind_disrnn_wrapper_2 {
	tag 'capsule-4484939'
	container "$REGISTRY_HOST/capsule/b3b7a6af-76fe-4f30-ba15-e8255429f119"

	cpus 16
	memory '61 GB'
	accelerator 1
	label 'gpu'

	publishDir "$RESULTS_PATH/$index", saveAs: { filename -> new File(filename).getName() }

	input:
	path 'capsule/data/jobs'
	val index

	output:
	path 'capsule/results/*'

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=b3b7a6af-76fe-4f30-ba15-e8255429f119
	export CO_CPUS=16
	export CO_MEMORY=65498251264

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-4484939.git" capsule-repo
	else
		git clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-4484939.git" capsule-repo
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

workflow {
	// input data
	index = Channel.of(1..100000)

	// run processes
	capsule_rachel_aind_disrnn_dispatcher_1()
	capsule_rachel_aind_disrnn_wrapper_2(capsule_rachel_aind_disrnn_dispatcher_1.out.to_capsule_rachel_aind_disrnn_wrapper_2_1.flatten(), index)
}
