use context starter2024

include file("puzzle-data.arr")

fun process-file(file :: String)-> List<List<Number>>:
  doc: "read file and process the content to produce a list of list of numbers"
  string-split-all(file, "\n").map(lam(x): string-split-all(x, " ").map(lam(y): string-to-number(y).or-else(0) end) end)
end


# check:
#   report-lists = process-file(sample-input)

#   report-safe(report-lists) is 2
#   report-tolerant-safe(report-lists) is 4
# end


fun report-tolerant-safe(reports-lst :: List<List<Number>>) -> Number:
  doc: "consumes a list of lists and report the number of tolerant safe reports"

  fun helper(lst-reports :: List<List<Number>>, acc :: Number):
    cases (List) lst-reports:
      | empty => acc
      | link(f, r) => 
        if is-tolerant-safe(f):
          helper(r, acc + 1)
        else:
          helper(r, acc)
        end
    end
  end

  helper(reports-lst, 0)


where:
  report-tolerant-safe([list: [list:7, 6, 4, 2, 1], [list: 1, 2, 7, 8, 9], [list: 9, 7, 6, 2, 1], [list: 1, 3, 2, 4, 5], [list: 8, 6, 4, 4, 1],[list: 1, 3, 6, 7, 9]]) is 4

end


fun report-safe(reports :: List<List<Number>>) -> Number:
  doc: "consumes a list of reports and return the number of safe reports"

  fun helper(lst :: List<List<Number>>, acc :: Number):
    cases (List) lst:
      | empty => acc
      | link(f, r) => 
        if is-safe(f):
          helper(r, acc + 1)
        else:
          helper(r, acc)
        end
    end
  end

  helper(reports, 0)

where:
  report-safe([list: [list:7, 6, 4, 2, 1], [list: 1, 2, 7, 8, 9], [list: 9, 7, 6, 2, 1], [list: 1, 3, 2, 4, 5], [list: 8, 6, 4, 4, 1],[list: 1, 3, 6, 7, 9]]) is 2

end


fun is-tolerant-safe(lst :: List<Number>) -> Boolean:
  doc: "process a list and determine if it is safe. This is a variant of is-safe and tolerate a single bad level"
  
  
  fun helper(seen, n-lst):
    cases (List) n-lst:
      | empty => false
      | link(f, r) =>
        if is-safe(seen.append(r)):
          true
        else:
          new-seen = seen.append([list: f])
          helper(new-seen, r)
        end
    end
  end


  if is-safe(lst):
    true
  else:
    helper(empty, lst)
  end

where:
  is-tolerant-safe([list: 1, 3, 2, 4, 5]) is true
  is-tolerant-safe([list: 8, 6, 4, 4, 1]) is true
  is-tolerant-safe([list: 91, 91, 93, 93, 95, 96, 99]) is false
  
end


fun is-safe(lst :: List<Number>) -> Boolean:
  doc: "process a list and determine if it is safe. A list is safe if  either all the numbers are increasing or decreasing and if two adjacent levels differe by at least one and at most three"

  fun helper(num-lst, prev):

    cases (List) num-lst:
      | empty => true
      | link(f, r) => 
        if (num-abs(f - prev) >= 1) and (num-abs(f - prev) <= 3):
          helper(r, f)
        else:
          false
        end
    end
  end

  if is-sorted(lst):
    helper(lst.rest, lst.first)
  else:
    false
  end

where:
  is-safe([list: 7, 6, 4, 2, 1]) is true
  is-safe([list: 1, 2, 7, 8, 9]) is false
  is-safe([list: 9, 7, 6, 2, 1]) is false
  is-safe([list: 1, 3, 2, 4, 5]) is false
  is-safe([list: 8, 6, 4, 4, 1]) is false
  is-safe([list: 1, 3, 6, 7, 9]) is true
  is-safe([list: 91, 91, 93, 93, 95, 96, 99]) is false
end


fun is-sorted(l :: List<Number>) -> Boolean:
  doc: "determines if all element are sorted either in ascending or descending order"

  fun all-increasing(lst, prev):

    cases (List) lst:
      | empty => true
      | link(f, r) => 
        if f > prev:
          all-increasing(r, f)
        else:
          false
        end
    end
  end

  fun all-decreasing(lst, prev):
    cases (List) lst:
      | empty => true
      | link(f, r) => 
        if f < prev:
          all-decreasing(r, f)
        else:
          false
        end
    end
  end

  all-increasing(l.rest, l.first) or  all-decreasing(l.rest, l.first)
end