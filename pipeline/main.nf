#!/usr/bin/env nextflow
// hash:sha256:0041346bf6608b3d14c0f6bdd3e564d1adba5570a652ae3977bd553e705518c6

// capsule - aind-disrnn-dispatcher
process capsule_aind_disrnn_dispatcher_1 {
	tag 'capsule-8628612'
	container "$REGISTRY_HOST/published/0c6225dc-1bc2-4fa2-977f-ffa54408a907:v1"

	cpus 1
	memory '7.5 GB'

	output:
	path 'capsule/results/*', emit: to_capsule_aind_disrnn_wrapper_2_1

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=0c6225dc-1bc2-4fa2-977f-ffa54408a907
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git clone --filter=tree:0 --branch v1.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8628612.git" capsule-repo
	else
		git clone --branch v1.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8628612.git" capsule-repo
	fi
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_aind_disrnn_dispatcher_1_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-disrnn-wrapper
process capsule_aind_disrnn_wrapper_2 {
	tag 'capsule-1781932'
	container "$REGISTRY_HOST/published/7e3629e9-2e46-46b6-81b9-11b4e64899b2:v1"

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

	export CO_CAPSULE_ID=7e3629e9-2e46-46b6-81b9-11b4e64899b2
	export CO_CPUS=16
	export CO_MEMORY=65498251264

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	ln -s "/tmp/data/disrnn_dataset_778077" "capsule/data/disrnn_dataset_778077" # id: 76fc65d3-eec4-4578-a20d-499193fc920e
	ln -s "/tmp/data/disrnn_dataset_774212" "capsule/data/disrnn_dataset_774212" # id: ad5ec889-f4e0-45a2-802c-f843266d3cce
	ln -s "/tmp/data/disrnn_dataset_781173" "capsule/data/disrnn_dataset_781173" # id: 9788eb8d-ea88-4c60-bacc-1a23efd2f5e1
	ln -s "/tmp/data/disrnn_dataset_781162" "capsule/data/disrnn_dataset_781162" # id: 8eaa487e-e78c-4635-b24b-eabe680a55ae
	ln -s "/tmp/data/disrnn_dataset_779531" "capsule/data/disrnn_dataset_779531" # id: 64fa1cb4-8af8-4d96-a965-3454d59439f6

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git clone --filter=tree:0 --branch v1.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-1781932.git" capsule-repo
	else
		git clone --branch v1.0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-1781932.git" capsule-repo
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
	capsule_aind_disrnn_dispatcher_1()
	capsule_aind_disrnn_wrapper_2(capsule_aind_disrnn_dispatcher_1.out.to_capsule_aind_disrnn_wrapper_2_1.flatten(), index)
}
