global class scheduledMerge implements Schedulable{
   global void execute(SchedulableContext SC) {
      scheduledMerge m = new scheduledMerge();
        String sch = '20 30 8 10 2 ?';
        system.schedule('Merge Job', sch, m);   }
}