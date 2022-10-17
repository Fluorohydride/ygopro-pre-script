--サークル・オブ・フェアリー
--Script by 神数不神
function c101111042.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101111042,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_INSECT+RACE_PLANT))
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101111042,1))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101111042)
	e2:SetCondition(c101111042.damcon)
	e2:SetTarget(c101111042.damtg)
	e2:SetOperation(c101111042.damop)
	c:RegisterEffect(e2)
end
function c101111042.damcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetBattleMonster(tp)
	return a and a:IsRace(RACE_INSECT+RACE_PLANT) and eg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)
end
function c101111042.damfilter(c,e)
	return c:GetAttack()>0 and c:IsCanBeEffectTarget(e) and c:IsLocation(LOCATION_GRAVE)
end
function c101111042.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c101111042.filter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c101111042.damfilter,1,nil,e) end
	local g=eg
	if #eg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		e=eg:FilterSelect(tp,c101111042.damfilter,1,1,nil,e)
	end
	Duel.SetTargetCard(g)
	local value=e:GetHandler():GetAttack()/2
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,value)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,value)
end
function c101111042.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local value=tc:GetAttack()/2
		if Duel.Damage(1-tp,value,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			Duel.Recover(tp,value,REASON_EFFECT)
		end
	end
end
