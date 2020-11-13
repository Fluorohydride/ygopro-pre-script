--Fist of Fate
--scripted by TOP
function c100272002.initial_effect(c)
    aux.AddCodeList(c,10000030)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(100272002,0))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_NEGATE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e1:SetCountLimit(1,100272002+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c100272002.condition)
    e1:SetTarget(c100272002.target)
    e1:SetOperation(c100272002.activate)
    c:RegisterEffect(e1)
end
function c100272002.actfilter(c)
    return c:IsFaceup() and c:IsOriginalCodeRule(10000030)
end
function c100272002.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c100272002.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c48152161.filter(c)
    return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_EFFECT)
end
function c48152161.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c48152161.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c48152161.activate(e,tp,eg,ep,ev,re,r,rp)
    local exc=nil
    if e:IsHasType(EFFECT_TYPE_ACTIVATE) then exc=e:GetHandler() end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectMatchingCard(tp,c48152161.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,exc)
    if g:GetCount()>0 then
        local tc=g:GetFirst()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
	  	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_FIELD)
        e3:SetCode(EFFECT_DISABLE)
        e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
        e3:SetTarget(c24224830.distg)
        e3:SetLabelObject(tc)
        e3:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e3,tp)
        local e4=Effect.CreateEffect(e:GetHandler())
        e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e4:SetCode(EVENT_CHAIN_SOLVING)
        e4:SetCondition(c24224830.discon)
        e4:SetOperation(c24224830.disop)
        e4:SetLabelObject(tc)
        e4:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e4,tp)
			  if (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.SelectYesNo(tp,aux.Stringid(100272002,0)) then
			      local sg=Duel.GetMatchingGroup(c18144506.filter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
			      Duel.Destroy(sg,REASON_EFFECT)
			  end
		   end
    end
end
