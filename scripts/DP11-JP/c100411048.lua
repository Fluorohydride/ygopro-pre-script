--月光融合
--Lunalight Fusion
--Scripted by Eerie Code
--edited by Szefo09
function c100411048.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,100411048+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c100411048.target)
    e1:SetOperation(c100411048.activate)
    c:RegisterEffect(e1)
end
function c100411048.filter1(c,e)
    return c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c100411048.exfilter0(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xdf) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c100411048.exfilter1(c,e)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xdf) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c100411048.filter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsSetCard(0xdf) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c100411048.fcheck(tp,sg,fc)
    return sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA+LOCATION_DECK)<=1
end
function c100411048.cfilter(c)
    return c:GetSummonLocation()==LOCATION_EXTRA
end
function c100411048.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=tp
        local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsAbleToGrave,nil)
        if Duel.IsExistingMatchingCard(c100411048.cfilter,tp,0,LOCATION_MZONE,1,nil) then
            local sg=Duel.GetMatchingGroup(c100411048.exfilter0,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil)
            if sg:GetCount()>0 then
                mg1:Merge(sg)
                Auxiliary.FCheckAdditional=c100411048.fcheck
            end
        end
        local res=Duel.IsExistingMatchingCard(c100411048.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        Auxiliary.FCheckAdditional=nil
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg2=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(c100411048.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100411048.activate(e,tp,eg,ep,ev,re,r,rp)
    local chkf=tp
    local mg1=Duel.GetFusionMaterial(tp):Filter(c100411048.filter1,nil,e)
    local exmat=false
    if Duel.IsExistingMatchingCard(c100411048.cfilter,tp,0,LOCATION_MZONE,1,nil) then
        local sg=Duel.GetMatchingGroup(c100411048.exfilter1,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e)
        if sg:GetCount()>0 then
            mg1:Merge(sg)
            exmat=true
        end
    end
    if exmat then Auxiliary.FCheckAdditional=c100411048.fcheck end
    local sg1=Duel.GetMatchingGroup(c100411048.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
    Auxiliary.FCheckAdditional=nil
    local mg2=nil
    local sg2=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg2=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg2=Duel.GetMatchingGroup(c100411048.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
    end
    if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
        local sg=sg1:Clone()
        if sg2 then sg:Merge(sg2) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg:Select(tp,1,1,nil)
        local tc=tg:GetFirst()
        mg1:RemoveCard(tc)
        if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
            if exmat then Auxiliary.FCheckAdditional=c100411048.fcheck end
            local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
            Auxiliary.FCheckAdditional=nil
            tc:SetMaterial(mat1)
            Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
        else
            local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
            local fop=ce:GetOperation()
            fop(ce,e,tp,tc,mat2)
        end
        tc:CompleteProcedure()
    end
end
