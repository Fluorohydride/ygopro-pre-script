--象牙角笛
function c101101072.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetCountLimit(1,101101072+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c101101072.target)
    e1:SetOperation(c101101072.activate)
    c:RegisterEffect(e1)   
end
function c101101072.rmfilter(c)
    return c:GetType()==TYPE_EQUIP+TYPE_SPELL and c:IsAbleToRemove()
end
function c101101072.desfilter(c)
    return c:IsSetCard(0x247) and c:IsType(TYPE_MONSTER)
end
function c101101072.spfilter(c,e,tp)
    return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsLevelBelow(9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101101072.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(c101101072.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
    local g1=Duel.GetMatchingGroup(c101101072.desfilter,tp,LOCATION_MZONE,0,nil)    
    local b1=Duel.IsExistingMatchingCard(c101101072.rmfilter,tp,LOCATION_GRAVE+LOCATION_SZONE,0,1,nil)
    local b2=Duel.IsExistingMatchingCard(c101101072.desfilter,tp,LOCATION_MZONE,0,1,nil) and g:CheckWithSumEqual(Card.GetLevel,9,1,3)
    if chk==0 then return b1 or b2 end
    local op=0
    if b1 and b2 then
        op=Duel.SelectOption(tp,aux.Stringid(101101072,0),aux.Stringid(101101072,1))
    elseif b1 then
        op=Duel.SelectOption(tp,aux.Stringid(101101072,0))
    else op=Duel.SelectOption(tp,aux.Stringid(101101072,1))+1 end
    e:SetLabel(op)
    if op==0 then
        e:SetCategory(CATEGORY_REMOVE)
        Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
    else
        e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    end
end
function c101101072.spcheck(g)
    return g:GetSum(Card.GetLevel)==9
end
function c101101072.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if e:GetLabel()==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101101072.rmfilter),tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,1,nil)
        if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(101101072,2)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
            if g:GetCount()>0 then
                Duel.HintSelection(g)
                Duel.Destroy(g,REASON_EFFECT)
            end
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local g=Duel.SelectMatchingCard(tp,c101101072.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.HintSelection(g)
            Duel.Destroy(g,REASON_EFFECT)
            Duel.BreakEffect()
            local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
            if ft<=0 then return end
            if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
            local g=Duel.GetMatchingGroup(c101101072.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sg=g:SelectSubGroup(tp,c101101072.spcheck,false,1,ft)
            local tc=sg:GetFirst()
            for tc in aux.Next(sg) do
                if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
                    local e1=Effect.CreateEffect(c)
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetCode(EFFECT_DISABLE)
                    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                    tc:RegisterEffect(e1)
                    local e2=Effect.CreateEffect(c)
                    e2:SetType(EFFECT_TYPE_SINGLE)
                    e2:SetCode(EFFECT_DISABLE_EFFECT)
                    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
                    tc:RegisterEffect(e2)
                end
            end
        end
        Duel.SpecialSummonComplete()
    end
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetTargetRange(1,0)
    e3:SetTarget(c101101072.splimit)
    if Duel.GetTurnPlayer()==tp then
        e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
    else
        e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
    end
    Duel.RegisterEffect(e3,tp)
end
function c101101072.splimit(e,c)
    return not c:IsRace(RACE_WARRIOR)
end