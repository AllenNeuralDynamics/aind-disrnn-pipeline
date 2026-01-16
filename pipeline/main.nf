#!/usr/bin/env nextflow
// hash:sha256:b4f23a8cddebebb175f697b455a13f09cd72019275b189915dc66a2f7bfb5bda

// capsule - aind-disrnn-dispatcher-PCK_duplicate
process capsule_aind_disrnn_dispatcher_pck_duplicate_1 {
	tag 'capsule-8081844'
	container "$REGISTRY_HOST/capsule/f25e57f3-3736-4866-b03b-722382be4a04:efbcdd4123fe89272ae85b6c612d292d"

	cpus 1
	memory '7.5 GB'

	output:
	path 'capsule/results/*', emit: to_capsule_aind_disrnn_wrapper_pck_duplicate_2_1

	script:
	"""
	#!/usr/bin/env bash
	set -e

	export CO_CAPSULE_ID=f25e57f3-3736-4866-b03b-722382be4a04
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8081844.git" capsule-repo
	else
		git -c credential.helper= clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-8081844.git" capsule-repo
	fi
	git -C capsule-repo checkout 953fcb3457436e54bfbe36a7698c93cd82cf0ce0 --quiet
	mv capsule-repo/code capsule/code && ln -s \$PWD/capsule/code /code
	rm -rf capsule-repo

	echo "[${task.tag}] running capsule..."
	cd capsule/code
	chmod +x run
	./run ${params.capsule_aind_disrnn_dispatcher_pck_duplicate_1_args}

	echo "[${task.tag}] completed!"
	"""
}

// capsule - aind-disrnn-wrapper-PCK_duplicate
process capsule_aind_disrnn_wrapper_pck_duplicate_2 {
	tag 'capsule-0307129'
	container "$REGISTRY_HOST/capsule/38d91e94-fb45-4fe7-8c72-abc09b219cb0:8a502b7f8168ebfd9adae94fb77dca50"

	cpus 1
	memory '7.5 GB'

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

	export CO_CAPSULE_ID=38d91e94-fb45-4fe7-8c72-abc09b219cb0
	export CO_CPUS=1
	export CO_MEMORY=8053063680

	mkdir -p capsule
	mkdir -p capsule/data && ln -s \$PWD/capsule/data /data
	mkdir -p capsule/results && ln -s \$PWD/capsule/results /results
	mkdir -p capsule/scratch && ln -s \$PWD/capsule/scratch /scratch

	echo "[${task.tag}] cloning git repo..."
	if [[ "\$(printf '%s\n' "2.20.0" "\$(git version | awk '{print \$3}')" | sort -V | head -n1)" = "2.20.0" ]]; then
		git -c credential.helper= clone --filter=tree:0 "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-0307129.git" capsule-repo
	else
		git -c credential.helper= clone "https://\$GIT_ACCESS_TOKEN@\$GIT_HOST/capsule-0307129.git" capsule-repo
	fi
	git -C capsule-repo checkout f8c6100d59c4c1df14ef8f1ec01428db16e51d72 --quiet
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
	capsule_aind_disrnn_dispatcher_pck_duplicate_1()
	capsule_aind_disrnn_wrapper_pck_duplicate_2(capsule_aind_disrnn_dispatcher_pck_duplicate_1.out.to_capsule_aind_disrnn_wrapper_pck_duplicate_2_1.flatten(), index)
}
