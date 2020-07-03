nextflow.preview.dsl=2

process foo {
    output:
      path 'foo.txt'
    script:
      """
      echo "Hello" > foo.txt
      """
}

 process bar {
    input:
      path x
    output:
      path 'bar.txt'
    script:
      """
      cat $x > bar.txt
      echo " World" >> bar.txt
      """
}

workflow {
    foo()
    bar(foo.out)
}
