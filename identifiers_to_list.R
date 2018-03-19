
identifiers_to_list <- function(csv.file) {
    if (is.character(csv.file)==FALSE) {
        stop("csv.file must be of class character")
    }
        this.file <- read.csv(file=csv.file, header=TRUE)
        this.table <- cbind(as.character(this.file[,3]), as.character(this.file[,4]))
        these.pops <- unique(this.table[,2])
        #print(length(these.pops))
        this.list <- vector(mode="list", length=length(these.pops))
        names(this.list) <- these.pops
        for (i in 1:length(these.pops)) {
            this.pop <- these.pops[i]
            this.ind <- which(this.table[,2]==this.pop)
            my.indvs <- this.table[this.ind,1]
            #print(head(my.indvs))
            this.list[[i]] <- my.indvs
        }
        return(this.list)
}
        
